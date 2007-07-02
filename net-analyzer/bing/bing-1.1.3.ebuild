# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/bing/bing-1.1.3.ebuild,v 1.14 2007/07/02 14:36:02 peper Exp $

DESCRIPTION="A point-to-point bandwidth measurement tool."
SRC_URI="mirror://debian/pool/main/b/bing/${PN}_${PV}.orig.tar.gz"
HOMEPAGE="http://fgouget.free.fr/bing/index-en.shtml"
RESTRICT="mirror"

KEYWORDS="~amd64 ia64 ppc sparc x86"
SLOT="0"
LICENSE="as-is"
IUSE=""

RDEPEND="virtual/libc"
DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i \
		-e "s:#COPTIM = -g: COPTIM = ${CFLAGS}:" Makefile || \
			die "sed Makefile failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dobin bing
	doman unix/bing.8
	dodoc ChangeLog Readme.{1st,txt}
}
