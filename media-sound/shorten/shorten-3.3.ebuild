# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/shorten/shorten-3.3.ebuild,v 1.12 2004/04/26 04:05:12 agriffis Exp $

IUSE=""

DESCRIPTION="shorten is a fast, low complexity waveform coder (i.e. audio compressor)"
HOMEPAGE="http://etree.org/shnutils/shorten/"
SRC_URI="http://etree.org/shnutils/shorten/source/${P}.tar.gz"

SLOT="0"
LICENSE="as-is"
KEYWORDS="x86"

src_compile() {
	econf || die "econf failed"
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc AUTHORS LICENSE ChangeLog NEWS README
}
