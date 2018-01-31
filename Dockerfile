FROM ubuntu

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
            ca-certificates \
            cpanminus \
            make \
            wget \
    && \
    apt-get clean

ENV GETDEB_SOURCES="http://archive.getdeb.net/ubuntu xenial-getdeb apps"
RUN echo deb ${GETDEB_SOURCES} > /etc/apt/sources.list.d/getdeb.list && \
    wget -q -O- http://archive.getdeb.net/getdeb-archive.key | apt-key add - && \
    apt-get update && \
    apt-get install -y \
            gnucash \
    && \
    apt-get clean

RUN cpanm Finance::Quote

ENV SPIDEROAK_HTTP=https://spideroak.com/release/spideroak/deb_x64
ENV SPIDEROAK_DEB=spideroak.deb
RUN wget ${SPIDEROAK_HTTP} -O ${SPIDEROAK_DEB} && \
    dpkg -i ${SPIDEROAK_DEB} && \
    rm ${SPIDEROAK_DEB}

RUN useradd -g users -ms /bin/bash gnucash

USER gnucash
WORKDIR /home/gnucash

VOLUME /home/gnucash/.spideroak
