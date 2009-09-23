# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/picprog/picprog-1.7-r1.ebuild,v 1.3 2009/09/23 16:40:52 patrick Exp $

inherit eutils

DESCRIPTION="a pic16xxx series microcontroller programmer software for the simple serial port device"
HOMEPAGE="http://www.iki.fi/hyvatti/pic/picprog.html"
SRC_URI="http://www.iki.fi/hyvatti/pic/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="sys-devel/gcc
	virtual/libc
	sys-apps/coreutils"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/picprog-1.7-werner-almesberger.diff
	epatch "${FILESDIR}"/${P}-gcc41.patch
}

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}" || die
}

src_install() {
	dobin picprog || die
	dodoc README
	dohtml picprog.html *.png
	doman picprog.1
}
