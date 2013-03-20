VERSION=$(grep ^VERSION update.sh | sed 's/.*=//')

UNAME=$(shell uname)

all: build-all

include Makefile.${UNAME}

myemslauth.spec: myemslauth.spec.in
	sed "s/@VERSION@/$(VERSION)/g" < myemslauth.spec.in > myemslauth.spec

myemslauth.pc: myemslauth.pc.in
	sed "s/@VERSION@/$(VERSION)/g" < myemslauth.pc.in > myemslauth.pc

dist: clean
	bash build.sh

RPMOPTIONS=

rpm: dist
	rm -rf packages
	mkdir -p packages/bin packages/src
	rpmbuild --define '_rpmdir '`pwd`'/packages/bin' --define '_srcrpmdir '`pwd`'/packages/src' $(RPMOPTIONS) -ta myemsl-builddeps-$(VERSION).tar.gz

rpms: rpm

clean:
	rm -rf build