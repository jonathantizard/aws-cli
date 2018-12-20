FROM alpine:latest

ARG ACCESS_KEY_ID
ARG SECRET_ACCESS_KEY
ARG REGION
ARG OUTPUT

ENV AWSCLI_VERSION "1.16.76"
ENV AWSEB_VERSION "3.14.8"

RUN apk -v --update add \
python \
py-pip \
groff \
less \
mailcap \
&& \
pip install --upgrade pip && \
pip install setuptools && \
pip install --upgrade awscli==${AWSCLI_VERSION} && \
pip install --upgrade awsebcli==${AWSEB_VERSION)

RUN apk add docker

RUN apk add openrc && \
rc-update add docker boot

RUN rm /var/cache/apk/*

COPY aws-configure/ /aws-configure

RUN sed -i "s/ACCESS_KEY_ID/${ACCESS_KEY_ID}/g" /aws-configure/credentials
RUN sed -i "s/SECRET_ACCESS_KEY/${SECRET_ACCESS_KEY}/g" /aws-configure/credentials
RUN sed -i "s/REGION/${REGION}/g" /aws-configure/config
RUN sed -i "s/OUTPUT/${OUTPUT}/g" /aws-configure/config
RUN mkdir ~/.aws
RUN cp /aws-configure/* ~/.aws/
RUN rm -rf /aws-configure