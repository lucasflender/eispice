# build environment
FROM alpine:3.12 as build

RUN apk add --update --no-cache python3-dev py3-pip \
    build-base gfortran re2c

RUN apk add --update --no-cache python3-tkinter py3-virtualenv py3-wheel py3-numpy-dev py3-scipy

RUN ln -s /usr/bin/python3 /usr/bin/python

RUN pip3 install setuptools

WORKDIR /app
COPY . ./

RUN make wheel

# production environment
FROM tiangolo/uwsgi-nginx-flask:python3.8-alpine
RUN apk add --update --no-cache gfortran python3-tkinter py3-numpy py3-scipy
WORKDIR /app
COPY --from=build /app/*.whl .
RUN pip3 install -U ./eispice-0.11.6-cp38-cp38-linux_x86_64.whl
COPY main.py ./
CMD ["python", "main.py"]
