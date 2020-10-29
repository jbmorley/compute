# http://bingel.it/raspberry-pi-image-with-hashicorp-packer/

ARG ubuntu_version=20.04
FROM ubuntu:$ubuntu_version
# needed to do again after FROM due to docker limitation
ARG ubuntu_version

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp/
COPY requirements.txt .
RUN apt-get update --fix-missing
RUN bash -c "cat requirements.txt | xargs apt-get install -y"

ENV PACKER_DIR /usr/local/packer

WORKDIR /tmp/
RUN wget https://releases.hashicorp.com/packer/1.3.5/packer_1.3.5_linux_amd64.zip
RUN unzip packer_1.3.5_linux_amd64.zip -d "${PACKER_DIR}"
RUN rm packer_1.3.5_linux_amd64.zip
ENV PATH="${PATH}:${PACKER_DIR}"

WORKDIR /usr/local/src
RUN git clone https://github.com/solo-io/packer-builder-arm-image
WORKDIR /usr/local/src/packer-builder-arm-image
RUN git checkout b1c268e9d33105634c899e9095f0af097e1af432
RUN go mod download
RUN go build
RUN cp packer-builder-arm-image "${PACKER_DIR}"

ENV UTILITIES_DIR /usr/local/packer-utilities
COPY container-run-packer.sh ${UTILITIES_DIR}/
