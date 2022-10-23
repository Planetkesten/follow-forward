FROM debian

USER root
WORKDIR /python_template
ENV AWS_DEFAULT_REGION=us-east-1

RUN apt-get update -y
RUN apt-get install -y python curl nano 
RUN apt-get install -y bash
RUN apt install python3-venv python3-pip

COPY . /python_template
RUN pip install -r requirements.txt

ENV HOME /root
RUN bash
