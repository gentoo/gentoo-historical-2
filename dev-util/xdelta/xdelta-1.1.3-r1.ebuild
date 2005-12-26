# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/xdelta/xdelta-1.1.3-r1.ebuild,v 1.1 2005/12/26 07:55:53 ferringb Exp $

inherit eutils

DESCRIPTION="Computes changes between binary or text files and creates deltas"
HOMEPAGE="http://xdelta.sourceforge.net"
SRC_URI="mirror://sourceforge/xdelta/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~ia64 ppc ppc64 sparc x86"
IUSE=""

DEPEND="=dev-libs/glib-1.2*
	>=sys-libs/zlib-1.1.4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-m4.patch
	epatch "${FILESDIR}"/${P}-freegen.patch
	epatch "${FILESDIR}"/${P}-gcc4.patch
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
