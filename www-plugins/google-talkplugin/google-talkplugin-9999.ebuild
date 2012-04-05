# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-plugins/google-talkplugin/google-talkplugin-9999.ebuild,v 1.4 2012/04/05 14:50:33 ottxor Exp $

EAPI=4

inherit eutils nsplugins unpacker

if [ "${PV}" != "9999" ]; then
	DEB_PATCH="1"
	#http://dl.google.com/linux/talkplugin/deb/dists/stable/main/binary-i386/Packages
	MY_URL="http://dl.google.com/linux/talkplugin/deb/pool/main/${P:0:1}/${PN}"
	MY_PKG="${PN}_${PV}-${DEB_PATCH}_i386.deb"
	SRC_URI="x86? ( ${MY_URL}/${MY_PKG} )
		amd64? ( ${MY_URL}/${MY_PKG/i386/amd64} )"
else
	MY_URL="http://dl.google.com/linux/direct"
	MY_PKG="${PN}_current_i386.deb"
	SRC_URI=""
fi

DESCRIPTION="Video chat browser plug-in for Google Talk"

HOMEPAGE="http://www.google.com/chat/video"
IUSE="libnotify +system-libCg"
SLOT="0"

KEYWORDS="-* ~amd64 ~x86"
#GoogleTalkPlugin binary contains openssl
LICENSE="google-talkplugin openssl"
RESTRICT="strip mirror"

RDEPEND="|| ( media-sound/pulseaudio media-libs/alsa-lib )
	dev-libs/glib:2
	system-libCg? ( media-gfx/nvidia-cg-toolkit )
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libpng:1.2
	>=sys-libs/glibc-2.4
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXfixes
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXt
	sys-apps/lsb-release
	virtual/opengl
	libnotify? ( x11-libs/libnotify )"

DEPEND=""

INSTALL_BASE="opt/google/talkplugin"

QA_EXECSTACK="${INSTALL_BASE}/GoogleTalkPlugin"

QA_TEXTRELS="${INSTALL_BASE}/libnpg*.so"

QA_DT_HASH="${INSTALL_BASE}/libnpg.*so
	${INSTALL_BASE}/GoogleTalkPlugin"

S="${WORKDIR}"

LANGS="ar cs en et fr hu lt ms pl ru sv tl vi bg da fa gu id ja lv nl
sk ta tr bn de es fi hi is kn ml no sl te uk ca el fil hr it ko mr or
ro sr th ur"

for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

# nofetch means upstream bumped and thus needs version bump
pkg_nofetch() {
	einfo "This version is no longer available from Google."
	einfo "Note that Gentoo cannot mirror the distfiles due to license reasons, so we have to follow the bump."
	einfo "Please file a version bump bug on http://bugs.gentoo.org (search	existing bugs for ${PN} first!)."
}

src_unpack() {
	local pkg="${A:=${MY_PKG}}"
	if [ "${PV}" = "9999" ]; then
		use amd64 && pkg="${pkg/i386/amd64}"
		einfo "Fetching ${pkg}"
		wget "${MY_URL}/${pkg}" || die
	fi
	unpacker ${pkg}
}

src_install() {
	unpacker usr/share/doc/google-talkplugin/changelog.Debian.gz
	dodoc changelog.Debian

	exeinto "/${INSTALL_BASE}"
	doexe "${INSTALL_BASE}"/GoogleTalkPlugin
	for i in "${INSTALL_BASE}"/libnpg*.so; do
		doexe "${i}"
		inst_plugin "/${i}"
	done

	#install screen-sharing stuff - bug #397463
	insinto "/${INSTALL_BASE}"
	doins "${INSTALL_BASE}"/windowpicker.glade

	strip-linguas ${LANGS}
	for l in ${LINGUAS}; do
		insinto "/${INSTALL_BASE}"/locale/$l/LC_MESSAGES/
		doins "${INSTALL_BASE}"/locale/$l/LC_MESSAGES/windowpicker.mo
	done

	#install bundled libCg
	if ! use system-libCg; then
		exeinto "/${INSTALL_BASE}"/lib
		doexe "${INSTALL_BASE}"/lib/*.so
	fi
}
