# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/gngeo/gngeo-0.5.9a.ebuild,v 1.1 2003/07/29 10:43:54 msterret Exp $

DESCRIPTION="A NeoGeo emulator"
HOMEPAGE="http://m.peponas.free.fr/gngeo/"
SRC_URI="http://m.peponas.free.fr/gngeo/download/${P}.tar.gz"

KEYWORDS="x86 ppc"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="sys-libs/zlib
	x86? ( >=dev-lang/nasm-0.98 )
	>=media-libs/libsdl-1.2"

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	dodoc AUTHORS NEWS README sample_gngeorc
}

pkg_postinst() {
    einfo
	einfo "A licensed NeoGeo BIOS copy is required to run the emulator."
	einfo
}
