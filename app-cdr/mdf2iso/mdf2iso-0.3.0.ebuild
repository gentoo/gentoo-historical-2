# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/mdf2iso/mdf2iso-0.3.0.ebuild,v 1.1.1.1 2005/11/30 09:42:28 chriswhite Exp $

inherit toolchain-funcs

DESCRIPTION="Alcohol 120% bin image to ISO image file converter"
HOMEPAGE="http://mdf2iso.berlios.de/"
SRC_URI="http://download.berlios.de/${PN}/${P}-src.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""
DEPEND="virtual/libc"

S=${WORKDIR}/${PN}

src_compile() {
	econf CFLAGS="${CFLAGS}" || die "configure failed"
	emake || die "make failed"
}

src_install() {
	dodoc ChangeLog
	dobin src/${PN} || die "dobin failed"
}
