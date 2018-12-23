FROM python:2.7-alpine

ARG ACCESS_KEY_ID
ARG SECRET_ACCESS_KEY
ARG REGION
ARG OUTPUT

ENV AWSCLI_VERSION "1.16.76"
ENV AWSEB_VERSION "3.14.8"
ENV AWSSAM_VERSION "0.10.0"
ENV NODE_VERSION "8"


RUN apk -vv --no-cache add docker

RUN apk -vv add --no-cache --virtual .build-deps gcc musl-dev
RUN apk -vv add --no-cache nodejs nodejs-npm

RUN pip install awscli && \
pip install awsebcli && \
pip install aws-sam-cli

#RUN apk add openrc && \
#rc-update add docker boot

RUN apk del .build-deps

RUN rm -rf /root/.cache

COPY aws-configure/ /aws-configure

RUN sed -i "s/ACCESS_KEY_ID/${ACCESS_KEY_ID}/g" /aws-configure/credentials && \
    sed -i "s/SECRET_ACCESS_KEY/${SECRET_ACCESS_KEY}/g" /aws-configure/credentials && \
    sed -i "s/REGION/${REGION}/g" /aws-configure/config && \
    sed -i "s/OUTPUT/${OUTPUT}/g" /aws-configure/config && \
    mkdir ~/.aws && \
    cp /aws-configure/* ~/.aws/

RUN rm -rf /aws-configure