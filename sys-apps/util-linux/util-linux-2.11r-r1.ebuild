# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: System Team <system@gentoo.org>
# Author: Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/util-linux/util-linux-2.11r-r1.ebuild,v 1.1 2002/07/09 11:41:32 aliz Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Various useful Linux utilities"
SRC_URI="http://www.kernel.org/pub/linux/utils/${PN}/${P}.tar.gz
         cpryt? ( http://www.kernel.org/pub/linux/kernel/people/hvr/util-linux-patch-int/${P}.patch.gz )"

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.2-r2
	sys-apps/pam-login"

RDEPEND="$DEPEND sys-devel/perl
	nls? ( sys-devel/gettext )"

SLOT="0"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${WORKDIR}
	cd ${S}
	if [ ! -z "`use crypt`" ]
	then
		 gunzip -c ${DISTDIR}/${P}.patch.gz | patch -p1 || die
	fi
	cp MCONFIG MCONFIG.orig
	sed -e "s:-pipe -O2 \$(CPUOPT) -fomit-frame-pointer:${CFLAGS}:" \
		-e "s:CPU=.*:CPU=${CHOST%%-*}:" \
		-e "s:HAVE_PAM=no:HAVE_PAM=yes:" \
		-e "s:HAVE_SLN=no:HAVE_SLN=yes:" \
		-e "s:HAVE_TSORT=no:HAVE_TSORT=yes:" \
		-e "s:usr/man:usr/share/man:" \
		-e "s:usr/info:usr/share/info:" \
			MCONFIG.orig > MCONFIG
}

src_compile() {

	./configure || die

	if [ -z "`use nls`" ]
	then
		cp defines.h defines.h.orig	
		grep -v "ENABLE_NLS" \
			defines.h.orig > defines.h
		cp defines.h defines.h.orig
		grep -v "HAVE_libintl_h" \
			defines.h.orig > defines.h

		cp Makefile Makefile.orig
		sed -e "s:SUBDIRS=po \\\:SUBDIRS= \\\:g" \
			Makefile.orig > Makefile
	fi
	
	emake LDFLAGS="" || die
	cd sys-utils; makeinfo *.texi || die
}

src_install() {
	make DESTDIR=${D} install || die

	dodoc HISTORY MAINTAINER README VERSION
	docinto licenses
	dodoc licenses/* HISTORY
	docinto examples
	dodoc example.files/*
}

