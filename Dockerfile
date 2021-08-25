from ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

ARG ARG_UID
ARG ARG_GID

# dunno what's that
ENV NOTVISIBLE "in users profile"

ADD buildscript1.sh /
RUN /buildscript1.sh prepareUser && \
    /buildscript1.sh installSomeSw

ADD buildscript2.sh /
RUN /buildscript2.sh installMoreSw

USER user

ADD entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

