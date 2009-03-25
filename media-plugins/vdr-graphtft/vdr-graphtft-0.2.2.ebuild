# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-graphtft/vdr-graphtft-0.2.2.ebuild,v 1.2 2009/03/25 06:02:45 mr_bones_ Exp $

EAPI="2"

inherit vdr-plugin

DESCRIPTION="VDR plugin: GraphTFT"
HOMEPAGE="http://www.vdr-wiki.de/wiki/index.php/Graphtft-plugin"
SRC_URI="http://www.jwendel.de/vdr/${P}.tar.bz2
		http://www.jwendel.de/vdr/DeepBlue-horchi-0.0.11.tar.bz2"
#		http://www.jwendel.de/vdr/alien-vs-predator-0.0.11.tar.bz2"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"
IUSE="directfb graphtft-fe imagemagick"

DEPEND=">=media-video/vdr-1.6.0_p2-r1[graphtft]
		media-fonts/ttf-bitstream-vera
		media-libs/imlib2[png]
		imagemagick? ( media-gfx/imagemagick[png] )
		gnome-base/libgtop
		>=media-video/ffmpeg-0.4.8_p20090201
		directfb? ( dev-libs/DirectFB )
		graphtft-fe? ( x11-libs/qt-gui:4 )"

RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}_gentoo.diff" )

extpatch_v_check() {

	EXTPATCH_V="`cat /var/db/pkg/media-video/vdr-*/vdr-*.ebuild | grep EXT_V | head -n 1 | cut -c8-9`"

	if [ "${EXTPATCH_V}" -lt "65" ]; then
		echo
		eerror "You need an update of vdr with a newer EXTENSIONSPATCH version!"
		eerror "minimal version of Extensionspatch = 65!"
		eerror "graphtft will not work fullfilled"
		echo
	fi
}

pkg_setup() {
	vdr-plugin_pkg_setup

	extpatch_v_check
}

src_unpack() {
	vdr-plugin_src_unpack

	rm -r "${S}"/documents/CVS
}

src_prepare() {
	vdr-plugin_src_prepare

	sed -i "${S}"/imlibrenderer/fbrenderer/fbrenderer.c \
		-i "${S}"/imlibrenderer/dvbrenderer/mpeg2encoder.c \
		-i "${S}"/imlibrenderer/fbrenderer/mpeg2decoder.c \
		-i "${S}"/imlibrenderer/fbrenderer/mpeg2decoder.h \
		-e "s:ffmpeg/avcodec.h:libavcodec/avcodec.h:"

	sed -i "${S}"/imlibrenderer/fbrenderer/mpeg2decoder.c \
		-i "${S}"/imlibrenderer/dvbrenderer/mpeg2encoder.c \
		-e "s:ffmpeg/swscale.h:libswscale/swscale.h:"
}

src_compile() {
	vdr-plugin_src_compile

	if use graphtft-fe; then
		cd "${S}"/graphtft-fe
		sed -i build.sh -e "s:qmake-qt4:qmake:"
		./clean.sh
		./build.sh || die "build.sh failed"
	fi
}

src_install() {
	vdr-plugin_src_install

	insinto /usr/share/vdr/graphTFT/themes/DeepBlue/
	doins -r "${WORKDIR}"/DeepBlue/*

#	insinto /usr/share/vdr/graphTFT/themes/avp/
#	doins -r "${WORKDIR}"/avp/*

	dosym /usr/share/fonts/ttf-bitstream-vera /usr/share/vdr/graphTFT/fonts

	dodoc "${S}"/documents/*

	if use graphtft-fe; then
		cd "${S}"/graphtft-fe && dobin graphtft-fe
		doinit graphtft-fe
	fi
}

pkg_postinst() {
	vdr-plugin_pkg_postinst

	echo
	elog "Graphtft-fe user:"
	elog "Edit /etc/conf.d/vdr.graphtft"
	elog "/etc/init.d/graphtft-fe start"
	echo
}
