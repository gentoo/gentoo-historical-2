# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-gammu/python-gammu-0.9.ebuild,v 1.1 2006/01/02 13:12:41 mrness Exp $

inherit distutils

IUSE="doc"

DESCRIPTION="Python bindings for Gammu"
HOMEPAGE="http://www.cihar.com/gammu/python/"
SRC_URI="http://www.cihar.com/gammu/python/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND=">=app-mobilephone/gammu-1.04"
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
