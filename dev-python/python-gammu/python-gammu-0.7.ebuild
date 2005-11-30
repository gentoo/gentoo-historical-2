# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-gammu/python-gammu-0.7.ebuild,v 1.1.1.1 2005/11/30 10:10:19 chriswhite Exp $

inherit distutils

IUSE="doc"

DESCRIPTION="Python bindings for Gammu"
HOMEPAGE="http://www.cihar.com/gammu/python/"
SRC_URI="http://www.cihar.com/gammu/python/older/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~amd64"

RDEPEND=">=app-mobilephone/gammu-0.97.7"
DEPEND="dev-util/pkgconfig
		${RDEPEND}"

src_install() {
	DOCS="AUTHORS NEWS"
	distutils_src_install

	if use doc; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
	fi
}
