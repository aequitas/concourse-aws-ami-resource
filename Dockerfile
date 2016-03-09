FROM alpine:latest

# install aws cli https://hub.docker.com/r/anigeo/awscli/
RUN \
	mkdir -p /aws && \
	apk -Uuv add jq groff less python py-pip && \
	pip install awscli && \
	apk --purge -v del py-pip && \
	rm /var/cache/apk/*

# for jq
ENV PATH=/usr/local/bin:$PATH

# install asserts
ADD assets/ /opt/resource/
RUN chmod +x /opt/resource/*

# test
ADD tests/ /opt/resource-tests/
RUN set -ve; /opt/resource-tests/tests.sh
