FROM --platform=linux/arm64/v8 alpine:latest
LABEL maintainer="Emir Marques <emirdeliz@gmail.com>"

ENV OPENCV_VERSION=4.6.0

# Install requirements
RUN apk update && apk add linux-headers --update alpine-sdk 

# OpenCV dependencies
RUN apk update && apk upgrade && apk --no-cache add \
	bash \
	build-base \
	ca-certificates \
	clang-dev \
	clang \
	cmake>3.22 \
	coreutils \
	curl \ 
	freetype-dev \
	ffmpeg-dev \
	ffmpeg-libs \
	gcc \
	g++ \
	git \
	gettext \
	lcms2-dev \
	libavc1394-dev \
	libc-dev \
	libffi-dev \
	libjpeg-turbo-dev \
	libpng-dev \
	libressl-dev \
	libwebp-dev \
	linux-headers \
	make \
	musl \
	openjpeg-dev \
	openssl \
	python3 \
	openssh-client \
	tiff-dev \
	unzip \
	zlib-dev 

# Clone, build and install OpenCV
RUN cd /opt \
	&& wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
	&& unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip \
	&& wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip \
	&& unzip ${OPENCV_VERSION}.zip && rm ${OPENCV_VERSION}.zip \
	&& cd /opt/opencv-${OPENCV_VERSION} && mkdir build && cd build \
	&& cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_C_COMPILER=/usr/bin/clang \
	-D CMAKE_CXX_COMPILER=/usr/bin/clang++ \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D INSTALL_PYTHON_EXAMPLES=OFF \
	-D INSTALL_C_EXAMPLES=OFF \
	-D WITH_FFMPEG=ON \
	-D WITH_TBB=ON \
	-D OPENCV_EXTRA_MODULES_PATH=/opt/opencv_contrib-${OPENCV_VERSION}/modules \
	-D PYTHON_EXECUTABLE=/usr/local/bin/python \
	.. \
	&& make -j"$(nproc)" \ 
	&& make install \
	&& rm -rf /build

RUN mkdir source
WORKDIR /source