# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/google-musicmanager/google-musicmanager-1.0.22.3409_beta.ebuild,v 1.2 2011/12/15 04:02:38 ottxor Exp $

EAPI=4

inherit eutils

MY_URL="http://dl.google.com/linux/musicmanager/deb/pool/main/${P:0:1}/${PN}-beta"
MY_PKG="${PN}-beta_${PV/_beta}-r0_i386.deb"

DESCRIPTION="Google Music Manager is a application for adding music to your Google Music library."
HOMEPAGE="http://music.google.com"
SRC_URI="x86? ( ${MY_URL}/${MY_PKG} )
	amd64? ( ${MY_URL}/${MY_PKG/i386/amd64} )"

LICENSE="google-talkplugin Apache-2.0 MIT LGPL-2.1 gSOAP BSD FDL-1.2 MPL-1.1 openssl ZLIB as-is"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE="log"

RESTRICT="fetch strip"

RDEPEND="
	dev-libs/expat
	dev-libs/glib:2
	media-libs/flac
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libogg
	media-libs/libvorbis
	net-dns/libidn
	sys-libs/glibc
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/qt-core
	x11-libs/qt-gui
	log? ( dev-libs/log4cxx )
	"

DEPEND="app-arch/xz-utils
	app-admin/chrpath"

INSTALL_BASE="opt/google/musicmanager"

QA_TEXTRELS="${INSTALL_BASE}/libmpgdec.so.0"

QA_DT_HASH="${INSTALL_BASE}/.*"

S="${WORKDIR}/${INSTALL_BASE}"

pkg_nofetch() {
	elog "This version is no longer available from Google and the license prevents mirroring."
	elog "This ebuild is intended for users who already downloaded it previously and have problems"
	elog "with ${PV}+. If you can get the distfile from e.g. another computer of yours, or search"
	use amd64 && MY_PKG="${MY_PKG/i386/amd64}"
	elog "it with google: http://www.google.com/search?q=intitle:%22index+of%22+${MY_PKG}"
	elog "and copy the file ${MY_PKG} to ${DISTDIR}."
}

src_unpack() {
	# Avoid automagic usage of deb2targz (bug #384147, #375969#c22)
	echo ">>> Unpacking ${A} to ${PWD}"
	ar x "${DISTDIR}/${A}" || die
	unpack ./data.tar.lzma
}

src_install() {
	insinto "/${INSTALL_BASE}"
	doins config.xml product_logo*

	exeinto "/${INSTALL_BASE}"
	chrpath -d MusicManager || die
	doexe MusicManager google-musicmanager minidump_upload
	#TODO unbundle this
	doexe libaacdec.so libaudioenc.so.0 libmpgdec.so.0 libid3tag.so

	dosym /"${INSTALL_BASE}"/google-musicmanager /opt/bin/google-musicmanager

	make_desktop_entry "${PN}" "Google Music Manager" \
		"/${INSTALL_BASE}/product_logo_32.xpm" "AudioVideo;Audio;Player;Music"
}
