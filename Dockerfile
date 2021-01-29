FROM ubuntu:18.04 as builder

RUN apt-get update && \
	apt-get install -y g++ cmake zlib1g-dev libboost-system-dev \
		libboost-program-options-dev libpthread-stubs0-dev libfuse-dev \
		libudev-dev

COPY . .

RUN cd /pCloudCC/lib/pclsync/ && make clean && make fs
RUN cd /pCloudCC/lib/mbedtls/ && cmake . && make clean && make

RUN mkdir -p /build
RUN cd build && cmake ../pCloudCC/ && make clean && make

FROM ubuntu:18.04
RUN apt-get update && \
	apt-get install -y fuse lsb-release sqlite3 && \
	apt-get clean all
COPY --from=builder /build/libpcloudcc_lib.so /build/libsqlite3.a /usr/lib/
COPY --from=builder /build/pcloudcc /usr/bin/
COPY syncfolder /usr/bin/
ENV USERNAME=
ENV DB=/root/.pcloud/data.db
CMD pcloudcc -u $USERNAME -s -m /mnt/pCloudDrive