# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pylibpcap/pylibpcap-0.4.ebuild,v 1.1.1.1 2005/11/30 10:10:28 chriswhite Exp $

inherit distutils

DESCRIPTION="Python interface to libpcap"
HOMEPAGE="http://sourceforge.net/projects/${PN}/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 ~amd64"
IUSE=""

DEPEND="virtual/python
	virtual/libpcap"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PV}-swig.patch
}
src_install() {
	distutils_src_install
	insinto /usr/share/doc/${PF}/examples
	doins examples/*
}
