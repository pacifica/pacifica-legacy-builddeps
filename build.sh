#!/bin/bash

eval $(grep ^VERSION update.sh)

ln -s . myemsl-builddeps-$VERSION
tar \
  --exclude=myemsl-builddeps-$VERSION/myemsl-builddeps-$VERSION.tar.gz \
  --exclude=myemsl-builddeps-$VERSION/myemsl-builddeps-$VERSION \
  --exclude=myemsl-builddeps-$VERSION/.git \
  -czf myemsl-builddeps-$VERSION.tar.gz \
  myemsl-builddeps-$VERSION/*

rm myemsl-builddeps-$VERSION
