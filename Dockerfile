# Make an image common to the builder and runtime environments to ensure commonality
FROM alpine AS common
RUN apk add --no-cache libstdc++ freetype fontconfig nss

###

# Make a builder image
FROM common AS builder
RUN apk add --no-cache \
  alpine-sdk curl xz \
  cmake freetype-dev fontconfig-dev nss-dev cairo-dev gtk+-dev
  
# Download and extract a Poppler release
ARG POPPLER_VERSION=0.74.0
RUN mkdir /build && \
    cd /build && \
    curl https://poppler.freedesktop.org/poppler-$POPPLER_VERSION.tar.xz | tar xJ && \
    mv poppler-$POPPLER_VERSION poppler

# Patch it with WordPerfect symbol support
ADD poppler-$POPPLER_VERSION.patch /build/poppler/wordperfect.patch
RUN cd /build/poppler && patch -p1 < wordperfect.patch

# Build a minimal pdftotext executable
RUN mkdir /build/target && \
  cd /build/target && \
  cmake ../poppler -DENABLE_LIBOPENJPEG=none -DENABLE_DCTDECODER=none -DENABLE_CMS=none -DBUILD_SHARED_LIBS=none -DENABLE_QT5=off && \
  make pdftotext -j8

###

# Make a target image
FROM common AS target

# Copy in the build artifacts
COPY --from=builder /build/target/libpoppler.so* /usr/local/lib/
COPY --from=builder /build/target/utils/pdftotext /usr/local/bin/

# Set the entrypoint
ENTRYPOINT ["/usr/local/bin/pdftotext"]
