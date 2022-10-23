FROM python as builder

USER blueprint
WORKDIR /blueprint

RUN apt-get update -y 

COPY . /blueprint
RUN pip install -r requirements.txt

ENV HOME /home/blueprint
RUN bash
