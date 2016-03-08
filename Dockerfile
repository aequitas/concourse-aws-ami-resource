FROM alpine:latest

# install aws cli https://hub.docker.com/r/anigeo/awscli/
RUN \
	mkdir -p /aws && \
	apk -Uuv add jq groff less python py-pip && \
	pip install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*

# install asserts
ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*
