
# tomcat8.5-centos7
FROM openshift/base-centos7

MAINTAINER Mathias Lustraeten <mathias.luestraeten@gmail.com>

ENV TOMCAT_VERSION=8.5
ENV JAVA_HOME /usr/lib/jvm/jre


#Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description="Apache Tomcat 8.5 JEE Application Server" \
      io.k8s.display-name="Tomcat 8.5" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,jee,tomcat"

#Install required packages here:
RUN     yum -y install wget && \
        yum -y install tar && \
        yum -y install java-1.8.0-openjdk \
	yum clean all -y

# Install Tomcat
RUN wget http://ftp.fau.de/apache/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz && \
        tar -xvf apache-tomcat-8.5.9.tar.gz && \
        rm apache-tomcat-8.5.9.tar.gz && \
        mv apache-tomcat-8.5.9/* . && \
	rm -rf apache-tomcat-8.5.9

# Defines the location of the S2I
# Although this is defined in openshift/base-centos7 image it's repeated here
# to make it clear why the following COPY operation is happening
LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i
# Copy the S2I scripts from ./.s2i/bin/ to /usr/local/s2i when making the builder image
COPY ./.s2i/bin/ /usr/local/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["usage"]
