# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mediainfo/mediainfo-0.7.34.ebuild,v 1.1 2010/07/17 03:56:53 beandog Exp $

EAPI="2"

WX_GTK_VER="2.8"
inherit autotools wxwidgets multilib

DESCRIPTION="MediaInfo supplies technical and tag information about media files"
HOMEPAGE="http://mediainfo.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/source/${PN}/${PV}/${PN}_${PV}.tar.bz2"

S="${WORKDIR}/MediaInfo"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl debug libmms static wxwidgets"

RDEPEND="
	sys-libs/zlib
	!static? (
		media-libs/libzen[wxwidgets=]
		~media-libs/lib${P}[curl=,libmms=]
	)
	wxwidgets? ( x11-libs/wxGTK:${WX_GTK_VER}[X] )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	static? (
		media-libs/libzen[static-libs,wxwidgets=]
		~media-libs/lib${P}[curl=,libmms=,static-libs]
	)"

pkg_setup() {
	TARGETS="CLI"
	use wxwidgets && TARGETS+=" GUI"
}

src_prepare() {
	for x in ${TARGETS}; do
		cd "${S}/Project/GNU/${x}"
		eautoreconf
	done
}

src_configure() {
	for target in ${TARGETS}; do
		cd "${S}/Project/GNU/${target}"
		local myconf=""
		use wxwidgets && myconf="${myconf} --with-wxwidgets --with-wx-gui"
		econf \
			${myconf} \
			--disable-dependency-tracking \
			$(use_enable debug) \
			$(use_enable !static shared) \
			$(use_enable static static) \
			$(use_enable static staticlibs)
	done
}

src_compile() {
	for x in ${TARGETS}; do
		cd "${S}/Project/GNU/${x}"
		emake || die "emake failed failed for ${x}"
	done
}
src_install() {
	for x in ${TARGETS}; do
		cd "${S}/Project/GNU/${x}"
		einstall
		dodoc "${S}/History_${x}.txt" || die
		if [[ "${x}" = "GUI" ]]; then
			newicon "${S}/Source/Ressource/Image/MediaInfo.png" "${PN}.png"
			make_desktop_entry "${PN}-gui" "MediaInfo" "${PN}" "AudioVideo;GTK;"
		fi
	done

	dodoc "${S}/"*.html || die
}
