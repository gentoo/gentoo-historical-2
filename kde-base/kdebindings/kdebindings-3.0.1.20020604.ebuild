# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebindings/kdebindings-3.0.1.20020604.ebuild,v 1.4 2002/07/11 06:30:26 drobbins Exp $

# TODO: add gnustep bindings

inherit kde-patch kde-dist

DESCRIPTION="${DESCRIPTION}Bindings"

newdepend ">=kde-base/kdebase-${PV}
	=x11-libs/gtk+-1.2*
	sys-devel/perl
	python? ( dev-lang/python )
	java? (	virtual/jdk )
	=x11-libs/gtk+-1.2*
	=dev-libs/glib-1.2*
	>=kde-base/kdenetwork-${PV}
	mozilla? ( net-www/mozilla )"

use python									|| myconf="$myconf --without-python"
use java	&& myconf="$myconf --with-java=$(java-config --jdk-home)"	|| myconf="$myconf --without-java"
#myconf="$myconf --enable-objc"

export LIBPYTHON="`python-config`"

src_unpack()
{
    base_src_unpack
    
    if [ -z "`use mozilla`" ]; then
	# disable mozilla bindings/xpart
	cd ${S}
	cp configure configure.orig
	sed -e 's:mozilla_incldirs=:# mozilla_incldirs=:' configure.orig > configure
	chmod +x configure
    fi
}
