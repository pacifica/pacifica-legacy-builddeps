#!/bin/bash

eval $( grep ^VERSION update.sh)

./build.sh
rpmbuild -ta pacifica-builddeps-$VERSION.tar.gz --define '_rpmdir '`pwd`'/packages/bin' --define '_srcrpmdir '`pwd`'/packages/src' --define "LOCALREVISION `./svnver.sh .`"
