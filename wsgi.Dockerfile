# build environment
FROM ubuntu:20.04 as build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git curl build-essential \
    gfortran re2c python3 python3-dev

RUN apt-get install -y \
    python3-pip python3-tk \
    python3-venv python3-wheel python-is-python3

RUN pip3 install numpy scipy wheel setuptools

WORKDIR /app
COPY . ./

RUN make wheel

# production environment
FROM tiangolo/uwsgi-nginx-flask:python3.8
RUN apt-get update && apt-get install -y gfortran tk
RUN pip3 install numpy scipy
WORKDIR /app
COPY --from=build /app/*.whl .
RUN pip3 install -U ./eispice-0.11.6-cp38-cp38-linux_x86_64.whl
