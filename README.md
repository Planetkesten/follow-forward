"type"
# python_template_repo

Replace the contents of this README once the initial configuration is complete.

Created via "Use this template" button from template_repo

This is the python class of template repos. More child repos could include jupyter_notebook or flask.

## Consider other projects
* https://github.com/rochacbruno/fastapi-project-template
  ** variants for fastapi, Flask, simple python 
* https://github.com/leynier/python-template
  ** Supports Typer (cli), FastAPI, codecov, docs, autodeploy

## Philosophy

Use docker as much as possible. For example, call gitleaks via a docker  container.
Use Github Actions when appropriate. Do not over-expose security attack surface.
Use git branches to select the features of the template-repo to be enabled, git-merge to combine?

### When to use GitHub Actions

GitHub actions run on GitHub infrastructure and can access sensitive GitHub secrets.
Secrets can be exported via ngrok or similar tools, or code could be overwritten.
Branch protections should be used to prevent single PR catastrophic takeovers.
There is a github action which allows breakpoints in github actions via ssh into the GitHub
execution environment. This is a good mental model when considering Supply chain attacks 
when incorporating 3rd party actions.

3rd party actions can be pinned to a  specific content hash.
If the action requires high gh-action or credential privileges, assess the supply chain risk.
If the action is simple and maintained by a trusted source, consider un-pinned references.
If the action is complex, or source is a vendor risk, consider reviewing it thoroughly and forking.

* [Monitor](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html#keep-a-log) the activity of the 
credentials used in GitHub Actions workflows.

Experimental:
We used templating instead of forking to create this child repo without knowing if it will allow us to merge in specially tagged commits back into the parent template_repo.

Todo:

* Jupyter notebook support (possibly child template repo)
** docs via fastAI https://github.com/fastai/nbdev-template
** pip install nbdime
** pip install nbstripout


## configuration

If you are using osx, replace the "sed" commands with "gsed" (brew install gsed)
in configure_project.sh. To configure your project you should run:
```
./configure_project.sh MODULE="_your-projectname_" REGISTRY="_your-registry_"
```

## Roadmap

Buildpacks are a modern way of getting docker images for free, without using a Dockerfile, and 
using best practices as provided by the buildpack provider. We will be testing adding buildpack
flows, but for now, will keep our dev/prod Dockerfile flows as well. Explicit dockerfiles also
make sense when forking from projects that do not use podman and have Dockerfiles present.

## Github Actions

A lot of CI/CD best practices like building containers and pushing to PyPi have github actions 
which are fully supported by large orgs. We will be shifting to Github actions when appropriate.
Certain actions like scanning for secrets make more sense as a pre-commit hook than waiting to
push it to the repo. Security or developer workflow inner-loops may mean that we want to keep
some actions locally and only use the Github action as a backstop. 

You will need the following Github environment variables at the org or repo level for the Github
actions to work.

```
GAR_LOCATION
GCP_CREDENTIALS
GCP_PROJECT_ID
GCP_SERVICE_REGION
```

## Setup OICD Federated Workload Ideneity integration with GitHub

[Google-Github Federated Identity](https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions)
allows short-lived keys to be generated per run. The identity is associated with Github and the repo calling
the actions, and the permissions are determined by the github action 'permissions' and the identity which triggered
the action (eg. merge actor) which get bound to the specified GCP service account. This is more auditable
than a credentials file which could be exfiltrated by sufficiently privileged users.


--------------------------------------------------------------------------------------------------
## parent repo: template_repo

We assume for now that for minimum deployment utility we will need Docker and expect the following
Dockerfiles 
* Dockerfile -> symlink pointing to env you currently work on eg (dev.Dockerfile)
* dev.Dockerfile - lager with many dev tools
* prod.Dockerfile - hardened, remove dev tools  not needed for production 
* sec.Dockerfile - experimental and sometimes prohibitively hardened
* test.Dockerfile - staging/test gate accepting updates from sec. or dev. Dockerfiles


The archetype template child will be python_template_repo which will include package versioning (pip), setup.py, python linting, security checks for dependencies etc. If during the course of development we introduce a convention in template_repo_python which is not specific to python, we can merge that commit back into template_repo.

It's interesting to consider licensing since GitHub requires it to set up a repo. 
It seems natural to pick the least restrictive 
license (MIT) and child repos (forks) can only become more restrictive (GPLV3). 


## Gitleaks

Install gitleaks according to https://github.com/zricethezav/gitleaks.
If you prefer, you can use a container by creating the following /usr/local/bin/gitleaks.

```
#!/bin/bash

if [[ x"$@"x != "xx" ]]; then
  docker run -v `pwd`:/path zricethezav/gitleaks:latest -c /path/.gitleaks.toml --source=/path "$@"
else
  docker run -v `pwd`:/path zricethezav/gitleaks:latest -c /path/.gitleaks.toml --source=/path protect  --staged --verbose
fi
```

Then
```
chmod a+x /usr/local/bin/gitleaks
```

By default, pre-commit will only send new files to the .git/hooks/pre-commit. For the first
run, use the following to test all files, or --no-git.
 
```
pre-commit run --all-files
```

If you need to add a new detection pattern or allow certain strings, modify the .gitleaks.toml file.

If you want to see the redacted values or make other substantial modifications, copy the the
(gitleaks/.pre-commit-hooks.yaml)[https://github.com/zricethezav/gitleaks/blob/master/.pre-commit-hooks.yaml]
file to the repo, and then remove the `--redacted` flag or other changes needed, then run this.

```
pre-commit install
``` 
