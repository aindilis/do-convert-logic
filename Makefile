#!/usr/bin/make -f

SYSNAME=doconvertlogic

configure: configure-stamp

configure-stamp:
	touch configure-stamp

build: build-stamp

build-stamp: configure-stamp 
	touch build-stamp

clean:
	find . | grep '~$$' | xargs rm

install:
	cp ${SYSNAME} $(DESTDIR)/usr/bin/
	cp -ar data/*.raw $(DESTDIR)/usr/share/$(SYSNAME)/data
	cp -ar DoConvertLogic DoConvertLogic.pm $(DESTDIR)/usr/share/perl5

.PHONY: build clean install configure
