# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libextractor/libextractor-0.2.2.ebuild,v 1.2 2004/06/24 23:08:56 agriffis Exp $

inherit libtool eutils

DESCRIPTION="A simple library for keyword extraction"
HOMEPAGE="http://www.ovmj.org/~samanta/libextractor"
SRC_URI="http://www.ovmj.org/~samanta/libextractor/download/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="x86 sparc"
IUSE="oggvorbis static"

# does not work with rpm-4.2
DEPEND=">=sys-devel/libtool-1.4.1
	<app-arch/rpm-4.2
	oggvorbis? ( >=media-libs/libvorbis-1.0_beta4 )"

src_unpack() {
	unpack ${A}
	# patch their half baked attempt at supporting ogg vorbis
	epatch ${FILESDIR}/${P}-vorbisfile.patch
}

src_compile() {
	elibtoolize

	export CPPFLAGS="-I/usr/include/rpm"
	econf `use_enable static` || die
	make || die
}

src_install() {
	make DESTDIR=${D} install || die
}
