FROM python

USER root
WORKDIR /blueprint

RUN apt-get update -y
RUN apt-get install -y curl nano bash

COPY . /blueprint
RUN pip install -r requirements.txt

ENV HOME /root
RUN bash
