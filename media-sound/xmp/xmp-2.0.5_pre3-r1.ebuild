# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/xmp/xmp-2.0.5_pre3-r1.ebuild,v 1.7 2005/09/10 15:50:36 flameeyes Exp $

IUSE="xmms arts esd nas X oss"

inherit eutils

S="${WORKDIR}/${PN}-2.0.5-pre3"

DESCRIPTION="Extended Module Player"
HOMEPAGE="http://xmp.sf.net"
SRC_URI="mirror://sourceforge/xmp/${PN}-2.0.5pre3.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
#-amd64: 2.0.5_pre3-r1 - compilation nightmare
#-sparc: Segfaults
KEYWORDS="-amd64 x86 -sparc"

DEPEND="X? ( virtual/x11 )
	esd? ( media-sound/esound )
	nas? ( media-libs/nas )
	arts? ( kde-base/arts )
	xmms? ( media-sound/xmms )"

#	Nobody uses alsa5, but if they do, they can hand edit this...
#	alsa? ( =media-libs/alsa-lib-0.5* )


src_unpack() {
	unpack ${A}
	epatch ${FILESDIR}/${P}-gcc3.3.diff
}

src_compile() {
	local myconf="--disable-alsa"

#	use alsa \
#		&& myconf="${myconf} --enable-alsa" \
#		|| myconf="${myconf} --disable-alsa"

	use arts \
		&& myconf="${myconf} --enable-arts" \
		|| myconf="${myconf} --disable-arts"

	use esd \
		&& myconf="${myconf} --enable-esd" \
		|| myconf="${myconf} --disable-esd"

	use nas \
		&& myconf="${myconf} --enable-nas" \
		|| myconf="${myconf} --disable-nas"

	use oss \
		&& myconf="${myconf} --enable-oss" \
		|| myconf="${myconf} --disable-oss"

	use xmms \
		&& myconf="${myconf} --enable-xmms" \
		|| myconf="${myconf} --disable-xmms"

	use X \
		&& myconf="${myconf} --with-x" \
		|| myconf="${myconf} --with-x"

	econf ${myconf} || die

	make || die
}

src_install () {
	make DEST_DIR=${D} MAN_DIR=${D}/usr/share/man/man1 install || die
	dodoc README
}
