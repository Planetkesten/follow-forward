#!/bin/bash

set -e

function die {
    local message=$1
    [ -z "$message" ] && message="Died"
    echo "${BASH_SOURCE[1]}: line ${BASH_LINENO[0]}: ${FUNCNAME[1]}: $message." >&2
    exit 1
}

for ARGUMENT in "$@"
do

    KEY=$(echo $ARGUMENT | cut -f1 -d=)
    VALUE=$(echo $ARGUMENT | cut -f2 -d=)   

    case "$KEY" in
            MODULE)      MODULE=${VALUE} ;;
            REGISTRY)    REGISTRY=${VALUE} ;;
            *)   
    esac    


done

if [[ x${MODULE}x = "xx" || x${REGISTRY}x = "xx" ]]; then
   die "MODULE=$MODULE and REGISTRY=$REGISTRY must both be defined (MODULE=<module>)"   
fi

if [[ $OSTYPE == 'darwin'* ]]; then
  OSX_SED_FIX=''
else
  OSX_SED_FIX=
fi

DUMMY_MODULE='blueprint'
DUMMY_REGISTRY='docker.pkg.github.com/martinheinz/python-project-blueprint'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "\n${BLUE}Renaming variables and files...${NC}\n"

sed -i "$OSX_SED_FIX" s/$DUMMY_MODULE/$MODULE/g deploy/docker/dev.Dockerfile
sed -i "$OSX_SED_FIX" s/$DUMMY_MODULE/$MODULE/g deploy/docker/prod.Dockerfile
sed -i "$OSX_SED_FIX" s/$DUMMY_MODULE/$MODULE/g tests/context.py
sed -i "$OSX_SED_FIX" s/$DUMMY_MODULE/$MODULE/g tests/test_app.py
sed -i "$OSX_SED_FIX" s/$DUMMY_MODULE/$MODULE/g build.sh

if [[ -z $DUMMY_MODULE ]]; then
  mv $DUMMY_MODULE $MODULE
fi

sed -i "$OSX_SED_FIX" s/$DUMMY_MODULE/$MODULE/g pytest.ini
sed -i "$OSX_SED_FIX" s/$DUMMY_MODULE/$MODULE/g setup.cfg
sed -i "$OSX_SED_FIX" s~$DUMMY_REGISTRY~$REGISTRY~g Makefile
sed -i "$OSX_SED_FIX" s/$DUMMY_MODULE/$MODULE/g Makefile

echo -e "\n${BLUE}Testing if everything works...${NC}\n"

echo -e "\n${BLUE}Test: make run${NC}\n"
make run
echo -e "\n${BLUE}Test: make test${NC}\n"
make test

echo -e "\n${BLUE}Installing pre-commit hook for gitleaks...${NC}\n"
pre-commit install
