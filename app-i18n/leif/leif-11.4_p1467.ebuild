# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/leif/leif-11.4_p1467.ebuild,v 1.2 2005/01/01 14:33:36 eradicator Exp $

inherit iiimf eutils

DESCRIPTION="Language Engine is a component that provide actual Input Method service for IIIMF"

KEYWORDS="x86"
IUSE=""

DEPEND="dev-libs/eimil"

src_unpack() {
	unpack ${A}
	cd ${S}/testEIMIL
	sed -i -e 's,$(IM_LIBDIR)/EIMIL,/usr/lib,g' Makefile.* || die
}

src_install() {
	make DESTDIR=${D} \
		prefix=/usr \
		install || die

	dodoc ChangeLog
	for d in canna cm newpy sampleja* ude unit template ; do
		docinto $d
		dodoc ChangeLog README
	done
}
