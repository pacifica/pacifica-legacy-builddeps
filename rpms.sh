#!/bin/bash

VERSION=$( grep ^VERSION update.sh)

./build.sh
rpmbuild -ta myemsl-builddeps-$VERSION.tar.gz --define '_rpmdir '`pwd`'/packages/bin' --define '_srcrpmdir '`pwd`'/packages/src' --define "LOCALREVISION `./svnver.sh .`"
