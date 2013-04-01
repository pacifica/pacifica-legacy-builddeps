#!/bin/bash

eval $(grep ^VERSION update.sh)

ln -s . pacifica-builddeps-$VERSION
tar \
  --exclude=pacifica-builddeps-$VERSION/pacifica-builddeps-$VERSION.tar.gz \
  --exclude=pacifica-builddeps-$VERSION/pacifica-builddeps-$VERSION \
  --exclude=pacifica-builddeps-$VERSION/.git \
  -czf pacifica-builddeps-$VERSION.tar.gz \
  pacifica-builddeps-$VERSION/*

rm pacifica-builddeps-$VERSION
