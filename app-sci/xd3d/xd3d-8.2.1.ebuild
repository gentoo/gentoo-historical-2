# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-sci/xd3d/xd3d-8.2.1.ebuild,v 1.1 2004/05/20 12:48:10 xtv Exp $

DESCRIPTION="scientific visualization tool"

HOMEPAGE="http://www.cmap.polytechnique.fr/~jouve/xd3d/"
SRC_URI="http://www.cmap.polytechnique.fr/${P}.tar.gz"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86"

IUSE="icc"

DEPEND="virtual/x11 \
	icc? ( dev-lang/icc dev-lang/ifc )"

src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p1 < ${FILESDIR}/gentoo-${P}.diff
}

src_compile() {
	if use icc; then
		sed "s:##D##:${D}:g" < RULES.icc > RULES.gentoo
	else
		sed "s:##CFLAGS##:${CFLAGS}:g" < RULES.gentoo > RULES.linux
		sed "s:##D##:${D}:g" < RULES.linux > RULES.gentoo
	fi
	./configure -arch=gentoo

	make
}

src_install() {
	make install

	dodoc BUGS CHANGELOG FAQ FORMATS INSTALL LICENSE README
	insinto /usr/share/doc/${PF}
	doins Manuals/*

	dodir /usr/share/doc/${PF}/examples
	insinto /usr/share/doc/${PF}/examples
	doins Examples/*
}
