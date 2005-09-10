# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sonic-rainbow/sonic-rainbow-0.5.1.ebuild,v 1.6 2005/09/10 15:45:29 flameeyes Exp $

IUSE=""

inherit eutils

S=${WORKDIR}/${PN}
DESCRIPTION="a Linux GUI multimedia player"
HOMEPAGE="http://sonic-rainbow.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-BETA-${PV}.tar.gz"
LICENSE="GPL-2"

DEPEND="app-cdr/cdrtools
	>=media-libs/audiofile-0.2.4
	>=media-libs/libao-0.8
	>=media-libs/libcddb-0.9.4
	media-libs/libid3tag
	>=media-libs/libmad-0.14.2b
	>=media-libs/libogg-1.0
	>=media-libs/libvorbis-1.0
	media-libs/xine-lib
	>=media-sound/lame-3.91
	>=media-sound/vorbis-tools-1.0
	>=x11-libs/gtk+-1.2"

SLOT="0"
KEYWORDS="x86 ~amd64 ~sparc"

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch ${FILESDIR}/${P}-Makefile.patch
}

src_install() {
	make DESTDIR=${D} localedir=${D}/usr/share/locale install || die

	dodoc AUTHORS README
	dohtml doc/Sonic-Rainbow.html
}
