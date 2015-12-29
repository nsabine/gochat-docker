FROM rhel7:latest

MAINTAINER Kenneth D. Evensen <kevensen@redhat.com>

ENV GOPATH /home/1001/golang
ENV HOST 192.168.122.78

RUN yum install -y yum-utils && yum clean all; rm -rf /var/cache/yum
RUN yum install -y --disablerepo='*' --enablerepo='rhel-7-server-rpms' --enablerepo='rhel-7-server-extras-rpms' --enablerepo='rhel-7-server-optional-rpms' --enablerepo='rhel-server-rhscl-7-rpms' golang golang-cover golang-bin git-bzr bzr

RUN useradd 1001
EXPOSE 8080

ADD go/ $GOPATH
RUN chown -R 1001:1001 $GOPATH
RUN mkdir /opt/deployments; chown 1001:1001 /opt/deployments
USER 1001
RUN cd $GOPATH/src/github.com/rhtps/gochat/; go clean; go build
RUN cp $GOPATH/src/github.com/rhtps/gochat/gochat /opt/deployments
ENTRYPOINT ["/opt/deployments/gochat", "-addr=0.0.0.0:8080"]
