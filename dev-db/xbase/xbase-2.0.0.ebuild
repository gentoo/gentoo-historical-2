# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/xbase/xbase-2.0.0.ebuild,v 1.5 2005/01/01 17:44:47 eradicator Exp $

inherit base

DESCRIPTION="XBase is an xbase (i.e. dBase, FoxPro, etc.) compatible C++ class library"
HOMEPAGE="http://www.rekallrevealed.org/"
SRC_URI="http://www.rekallrevealed.org/packages/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~amd64"
IUSE="doc"

DEPEND="sys-devel/automake
	sys-devel/libtool
	virtual/libc"
RDEPEND="virtual/libc"

src_install() {
	base_src_install
	dodoc AUTHORS COPYING Changelog INSTALL NEWS README TODO
	if use doc; then
		rm html/Makefile*
		dohtml html/*
		insinto /usr/share/doc/${PF}/examples
		doins examples/*.cpp examples/Makefile.95
	fi
}