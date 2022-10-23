#!/usr/bin/env python

# distutils/setuptools install script for blueprint
import os
from setuptools import setup, find_packages

# Package info
NAME = 'blueprint'
ROOT = os.path.dirname(__file__)
__version__ = '0.0.1'
VERSION = __version__

# Requirements
requirements = []
with open(os.path.join(os.path.dirname(os.path.realpath(__file__)), 'requirements.txt')) as f:
    for r in f.readlines():
        requirements.append(r.strip())

# Setup
setup(
    name=NAME,
    version=VERSION,
    description='',
    long_description=open('README.rst').read(),
    author='kesten broughton',
    author_email='kesten.broughton@gmail.com',
    url='https://github.com/kbroughton/blueprint',
    entry_points={
        'console_scripts': [
            'blueprint = blueprint:main',
        ]
    },
    packages=[
        'blueprint' 
    ],
    package_data={
        'blueprint': [
            'requirements.txt',
        ]
    },
    include_package_data=True,
    install_requires=requirements,
    license='GNU General Public License v2 (GPLv2)',
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Intended Audience :: Developers',
        'Intended Audience :: Information Technology',
        'Intended Audience :: System Administrators',
        'Natural Language :: English',
        'License :: OSI Approved :: GNU General Public License v2 (GPLv2)',
        'Programming Language :: Python',
        'Programming Language :: Python :: 3.6'
    ],
    scripts=[
      'bin/blueprint',
    ]
)
