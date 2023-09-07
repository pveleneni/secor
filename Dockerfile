FROM --platform=linux/amd64 eclipse-temurin:11.0.20_8-jdk
# https://github.com/docker-library/openjdk/issues/145#issuecomment-334561903
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=894979
# RUN /etc/ssl/certs/java/cacerts ; 
RUN update-ca-certificates -f

RUN mkdir -p /opt/secor

# Prepare environment
ENV SECOR_HOME=/opt/secor
WORKDIR $SECOR_HOME

RUN groupadd --system --gid=9999 secor && \
    useradd --system --home-dir $SECOR_HOME --uid=9999 --gid=secor secor

ADD target/secor-*-bin.tar.gz $SECOR_HOME

COPY src/main/scripts/docker-entrypoint.sh /docker-entrypoint.sh
RUN find $SECOR_HOME -type d -exec chown -R secor:secor {} \;
RUN chown secor:secor /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

USER secor
ENTRYPOINT ["/docker-entrypoint.sh"]
