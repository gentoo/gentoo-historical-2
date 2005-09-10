# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sonic-rainbow/sonic-rainbow-0.6.2.1.ebuild,v 1.2 2005/09/10 15:45:29 flameeyes Exp $

inherit eutils

IUSE=""

S=${WORKDIR}/${PN}
DESCRIPTION="a Linux GUI multimedia player"
HOMEPAGE="http://sonic-rainbow.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-BETA-${PV}.tar.gz"
LICENSE="GPL-2"

DEPEND="virtual/cdrtools
	>=media-libs/audiofile-0.2.4
	>=media-libs/id3lib-3.8.3-r2
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
KEYWORDS="~x86 ~sparc ~amd64"

src_install() {
	make DESTDIR=${D} localedir=${D}/usr/share/locale install || die

	# Remove the docs they install
	rm -rf ${D}/usr/share/Sonic-Rainbow/

	dodoc AUTHORS README
	dohtml doc/Sonic-Rainbow.html
}
