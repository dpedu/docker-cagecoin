FROM ubuntu:trusty

ADD cagecoin-0.7.0-src /tmp/cagecoin-0.7.0-src/

RUN apt-get update ; \
    apt-get install -y make g++ libboost-all-dev libssl-dev libdb5.1++-dev libminiupnpc-dev supervisor ; \
    cd /tmp/cagecoin-0.7.0-src/src ; \
    make -f makefile.unix ; \
    mv cagecoind /usr/local/bin/ ; \
    rm -rf /tmp/cagecoin-0.7.0-src ; \
    cd ; \
    useradd -m crypto ; \
    su -c "mkdir /home/crypto/.cagecoin/" crypto ; \
    rm -rf /var/lib/apt/lists/*

ADD cagecoin.conf /home/crypto/.cagecoin/cagecoin.conf
ADD supervisor-cagecoin.conf /etc/supervisor/conf.d/cagecoin.conf

VOLUME /home/crypto/.cagecoin/
EXPOSE 8332 8333

ENTRYPOINT supervisord