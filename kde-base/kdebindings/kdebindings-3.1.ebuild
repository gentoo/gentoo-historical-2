# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebindings/kdebindings-3.1.ebuild,v 1.6 2003/01/21 21:08:42 danarmak Exp $
# TODO: add gnustep, objc bindings
inherit kde-dist 

DESCRIPTION="KDE library bindings for languages other than c++"

KEYWORDS="x86"

newdepend "~kde-base/kdebase-${PV}
	=x11-libs/gtk+-1.2*
	sys-devel/perl
	python? ( dev-lang/python )
	java? (	virtual/jdk )
	=dev-libs/glib-1.2*
	~kde-base/kdenetwork-${PV}
	mozilla? ( net-www/mozilla )"

use python									|| myconf="$myconf --without-python"
use java	&& myconf="$myconf --with-java=$(java-config --jdk-home)"	|| myconf="$myconf --without-java"

# obj bindings are officially broken
#myconf="$myconf --enable-objc"

# we need to have csant (from pnet, from portable.NET) in portage for qtsharp
export DO_NOT_COMPILE="$DO_NOT_COMPILE qtsharp"

export LIBPYTHON="`python-config`"

src_unpack()
{
    base_src_unpack
    
    if [ -z "`use mozilla`" ]; then
	# disable mozilla bindings/xpart, because configure doesn't seem to do so
	# even when it doesn't detect the mozilla headers
	cd ${S}/xparts
	cp Makefile.am Makefile.am.orig
	sed -e 's:mozilla::' Makefile.am.orig > Makefile.am
    fi
    
}

