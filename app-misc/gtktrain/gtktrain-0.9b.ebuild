# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/gtktrain/gtktrain-0.9b.ebuild,v 1.6 2002/11/30 20:47:38 vapier Exp $

DESCRIPTION="GUI app for calculating fastest train routes"
SRC_URI="http://www.on.rim.or.jp/~katamuki/software/train/${P}.tar.gz"
HOMEPAGE="http://www.on.rim.or.jp/~katamuki/software/train/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86"
IUSE="nls"

DEPEND=">=dev-libs/libtrain-0.9b
	>=gnome-base/gnome-libs-1.4.1.2-r1"

src_compile() {
	use nls || NLS_OPTION="--disable-nls"
	econf ${NLS_OPTION}
	emake || die
}

src_install() {
	einstall
}

pkg_postinst() {
	einfo "Japanese train routes are located:"
	einfo "    http://www.oohito.com/data/train/index.htm"
}
