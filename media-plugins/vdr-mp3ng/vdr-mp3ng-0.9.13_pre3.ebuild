# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-mp3ng/vdr-mp3ng-0.9.13_pre3.ebuild,v 1.4 2006/03/31 17:45:16 hd_brummy Exp $

inherit vdr-plugin

MY_P=${P/_pre3}-MKIV-pre3

S=${WORKDIR}/mp3ng-0.9.13-MKIV-pre3

DESCRIPTION="Plugin to play mp3 and ogg on VDR"
HOMEPAGE="http://www.glaserei-franz.de/VDR/Moronimo2/vdrplugins.htm"
SRC_URI="http://www.glaserei-franz.de/VDR/Moronimo2/downloads/${MY_P}.tar.gz
		mirror://gentoo/${PN}-pictures-0.0.1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="vorbis oss imagemagick"

DEPEND=">=media-video/vdr-1.2.6
		media-libs/libmad
		media-libs/libid3tag
		sys-libs/zlib
		media-libs/libsndfile
		vorbis? ( media-libs/libvorbis )
		imagemagick? ( media-gfx/imagemagick )
		!imagemagick? ( media-libs/imlib2 )"

src_unpack() {
	vdr-plugin_src_unpack

	epatch ${FILESDIR}/${P}-gentoo.diff

	use !vorbis && sed -i "s:#WITHOUT_LIBVORBISFILE:WITHOUT_LIBVORBISFILE:" Makefile
	use oss && sed -i "s:#WITH_OSS_OUTPUT:WITH_OSS_OUTPUT:" Makefile
	use imagemagick && sed -i Makefile -e "s:HAVE_IMLIB2:#HAVE_IMLIB2:" \
		-e "s:#HAVE_MAGICK:HAVE_MAGICK:"

	has_version ">=media-video/vdr-1.3.37" && epatch ${FILESDIR}/${P}-1.3.37.diff
}

src_install() {
	vdr-plugin_src_install

	insinto /etc/vdr/plugins/mp3ng
	doins	${FILESDIR}/mp3ngsources

	insinto /usr/share/vdr/mp3ng
	doins ${WORKDIR}/${PN}-pictures-0.0.1/*.jpg

	newbin examples/mount.sh.example mount-mp3ng.sh

	dodoc HISTORY MANUAL README README-MORONIMO examples/network.sh.example
}
