FROM ubuntu:14.04


####################
# Dependencies
####################

# Note: git and build-essential are required to build Kudu from source

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        autoconf automake curl gcc liboauth-dev libssl-dev \
        libsasl2-dev libtool patch python ntp unzip \
        libboost-all-dev pkg-config git build-essential && \
     rm -rf /var/lib/apt/lists/*



####################
# Building Kudu
####################

ENV KUDU_VERSION	master
ENV KUDU_HOME		/usr/local/kudu
ENV PATH		$PATH:$KUDU_HOME/thirdparty/installed/bin:$KUDU_HOME/build/latest

RUN git clone https://github.com/cloudera/kudu.git $KUDU_HOME && \
    cd $KUDU_HOME && \
    ./thirdparty/build-if-necessary.sh && \
    cmake . && \
    make -j8 && \
    make install


VOLUME /data/kudu-master /data/kudu-tserver



####################
# PORTS
####################
#
# https://github.com/cloudera/kudu/blob/master/docs/installation.adoc
# 
# TabletServer:
# 	 8050 = TabletServer Web UI
# 	 8051 = Master Web UI
#
EXPOSE 8050 8051
