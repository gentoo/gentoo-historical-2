# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: System Team <system@gentoo.org>
# Author: Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/sys-apps/util-linux/util-linux-2.11l-r1.ebuild,v 1.1 2002/04/02 05:09:13 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Various useful Linux utilities"
SRC_URI="http://www.kernel.org/pub/linux/utils/${PN}/${P}.tar.gz"

DEPEND="virtual/glibc >=sys-libs/ncurses-5.2-r2"

RDEPEND="$DEPEND sys-devel/perl
	nls? ( sys-devel/gettext )"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${WORKDIR}
	cd ${S}
	cp MCONFIG MCONFIG.orig
	sed -e "s:-pipe -O2 \$(CPUOPT) -fomit-frame-pointer:${CFLAGS}:"	\
		-e "s:CPU=.*:CPU=${CHOST%%-*}:"	\
		-e "s:HAVE_PAM=no:HAVE_PAM=yes:"	\
		-e "s:HAVE_SLN=no:HAVE_SLN=yes:"	\
		-e "s:HAVE_TSORT=no:HAVE_TSORT=yes:"	\
		-e "s:usr/man:usr/share/man:"	\
		-e "s:usr/info:usr/share/info:"	\
			MCONFIG.orig > MCONFIG
}

src_compile() {
	local myconf

	use nls || myconf="${myconf} --disable-nls"
	
	./configure 	\
		${myconf} || die

	emake LDFLAGS="" || die
	cd sys-utils; makeinfo *.texi || die ; cd ..
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc HISTORY MAINTAINER README VERSION
	docinto licenses
	dodoc licenses/* HISTORY
	docinto examples
	dodoc example.files/*
}
