# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/bbappconf/bbappconf-0.0.2.ebuild,v 1.9 2010/06/08 16:46:39 xarthisius Exp $

inherit autotools eutils

DESCRIPTION="utility that allows you to specify window properties in blackbox"
HOMEPAGE="http://bbtools.windsofstorm.net/"
SRC_URI="http://bbtools.windsofstorm.net/sources/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86 ~x86-fbsd"
IUSE="debug"

DEPEND="virtual/blackbox"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-fix-sigsegv.diff \
		"${FILESDIR}"/${P}-asneeded.patch \
		"${FILESDIR}"/${P}-docs.patch
	eautoreconf
}

src_compile() {
	econf $(use_enable debug)
	emake || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS BUGS ChangeLog NEWS README TODO data/README.bbappconf || die
}
