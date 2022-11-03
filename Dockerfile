FROM springci/graalvm-ce:java17-0.12.x
ARG ZLIB_VERSION=1.2.13
ARG INSTALL_ROOT=/opt/musl

WORKDIR $INSTALL_ROOT
RUN apt update \
    && apt install -y wget \
    && apt clean \
    && wget https://musl.cc/x86_64-linux-musl-native.tgz \
    && wget https://zlib.net/zlib-$ZLIB_VERSION.tar.gz \
    && tar -xvzf x86_64-linux-musl-native.tgz \
    && tar -xvzf zlib-$ZLIB_VERSION.tar.gz
ARG TOOLCHAIN_DIR=$INSTALL_ROOT/x86_64-linux-musl-native
WORKDIR $INSTALL_ROOT/zlib-$ZLIB_VERSION
RUN ./configure --prefix=$TOOLCHAIN_DIR --static && make && make install
RUN rm -rf $INSTALL_ROOT/zlib-$ZLIB_VERSION

ENV PATH=$INSTALL_ROOT/x86_64-linux-musl-native/bin:$PATH
WORKDIR /
