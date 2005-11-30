# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/cdircmp/cdircmp-0.3.ebuild,v 1.1 2004/05/02 18:30:02 kloeri Exp $

DESCRIPTION="Compare directories and select files to copy"
HOMEPAGE="http://home.hccnet.nl/paul.schuurmans/"
SRC_URI="http://home.hccnet.nl/paul.schuurmans/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=sys-libs/ncurses-5.4"

DEPEND="${RDEPEND}
	>=sys-apps/sed-4"

src_unpack() {
	unpack ${A}
	cd ${S}

	# Modify CFLAGS
	sed -i \
		-e "/^CFLAGS/s:-g:${CFLAGS}:" \
	Makefile || die "sed Makefile failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dodoc AUTHORS ChangeLog README

	dobin ${PN}
}
