# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-embedded/picprog/picprog-1.5.ebuild,v 1.3 2004/06/24 22:08:11 agriffis Exp $

DESCRIPTION="a pic16xxx series microcontroller programmer software for the simple serial port device"
HOMEPAGE="http://www.iki.fi/hyvatti/pic/${PN}.html"
SRC_URI="http://www.iki.fi/hyvatti/pic/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE=""
KEYWORDS="x86"
DEPEND="sys-devel/gcc
	virtual/glibc
	sys-apps/coreutils"

RDEPEND="virtual/glibc"

src_compile() {
	emake CXXFLAGS="${CXXFLAGS}" || die
}

src_install() {
	dobin picprog
	dodoc README #jdm*.png adapter.jpg
	dohtml picprog.html *.jpg *.png
	doman picprog.1
}
