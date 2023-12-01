FROM node:21.2-alpine3.18

WORKDIR /usr/src/app
COPY src .
COPY package.json .

RUN apk --no-cache add exiftool && \
    npm i \
    && apk update \
    && apk upgrade \
    # install perl and curl
    && apk add --no-cache curl perl \
    && curl --version \
    && perl -v \
    # install exiftool
    && mkdir -p /opt/exiftool \
    && cd /opt/exiftool \
    && EXIFTOOL_VERSION=`curl -s https://exiftool.org/ver.txt` \
    && EXIFTOOL_ARCHIVE=Image-ExifTool-${EXIFTOOL_VERSION}.tar.gz \
    && curl -s -O https://exiftool.org/$EXIFTOOL_ARCHIVE \
    && CHECKSUM=`curl -s https://exiftool.org/checksums.txt | grep SHA1\(${EXIFTOOL_ARCHIVE} | awk -F'= ' '{print $2}'` \
    && echo "${CHECKSUM}  ${EXIFTOOL_ARCHIVE}" | /usr/bin/sha1sum -c -s - \
    && tar xzf $EXIFTOOL_ARCHIVE --strip-components=1 \
    && rm -f $EXIFTOOL_ARCHIVE \
    && exiftool -ver

EXPOSE 80 443
CMD ["node", "index.js"]
