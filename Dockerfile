FROM ghcr.io/graalvm/native-image:22.3.1
ARG ZLIB_VERSION=1.2.13
ARG INSTALL_ROOT=/opt/musl

WORKDIR $INSTALL_ROOT
RUN microdnf install -y wget gzip \
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
