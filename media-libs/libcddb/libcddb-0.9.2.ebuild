# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libcddb/libcddb-0.9.2.ebuild,v 1.5 2004/06/24 23:06:20 agriffis Exp $

IUSE="doc"

DESCRIPTION="A library for accessing a CDDB server"
HOMEPAGE="http://libcddb.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
RESTRICT="nomirror"

SLOT="0"
LICENSE="LGPL-2"
KEYWORDS="x86 ~sparc"

DEPEND="doc? ( app-doc/doxygen )"

src_compile() {
	econf || die
	emake || die

	# Create API docs if needed and possible
	if use doc && has_version 'app-doc/doxygen'; then
		cd doc
		doxygen doxygen.conf
	fi
}

src_install() {
	make DESTDIR=${D} install

	dodoc AUTHORS Changelog COPYING INSTALL NEWS README THANKS TODO
	# Create API docs if needed and possible
	if use doc && has_version 'app-doc/doxygen'; then
		dohtml doc/html/*
	fi
}
