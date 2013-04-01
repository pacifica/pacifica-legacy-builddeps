VERSION=$(shell grep ^VERSION update.sh | sed 's/.*=//')
WINVER=$(shell echo -n 1.;echo $(VERSION) | sed 's/^[0]*//')

UNAME=$(shell uname)

all: build-all

include Makefile.${UNAME}

dist: clean
	bash build.sh

RPMOPTIONS=

rpm: dist
	rm -rf packages
	mkdir -p packages/bin packages/src
	rpmbuild --define '_rpmdir '`pwd`'/packages/bin' --define '_srcrpmdir '`pwd`'/packages/src' $(RPMOPTIONS) -ta pacifica-builddeps-$(VERSION).tar.gz

pacificabuilddepssdk.wxs: pacificabuilddepssdk.wxs.in
	echo $(WINVER)
	sed "s/@VERSION@/$(WINVER)/g" < pacificabuilddepssdk.wxs.in > pacificabuilddepssdk.wxs

rpms: rpm

clean:
	rm -rf build
	rm -rf packages
	rm -f pacificabuilddepssdk.wxs
	rm -rf build-win32.zip
	rm -rf pacifica-builddeps-*.tar.gz
