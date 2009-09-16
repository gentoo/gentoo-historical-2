# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/chromium-bin/chromium-bin-4.0.210.0_p26326.ebuild,v 1.1 2009/09/16 06:59:24 voyageur Exp $

EAPI="2"
inherit eutils multilib

# Latest revision id can be found at
# http://build.chromium.org/buildbot/snapshots/chromium-rel-linux/LATEST
MY_PV="${PV/[0-9.]*\_p}"

DESCRIPTION="Open-source version of Google Chrome web browser"
HOMEPAGE="http://code.google.com/chromium/"
SRC_URI="x86? ( http://build.chromium.org/buildbot/snapshots/chromium-rel-linux/${MY_PV}/chrome-linux.zip -> ${PN}-x86-${MY_PV}.zip )
	amd64? ( http://build.chromium.org/buildbot/snapshots/chromium-rel-linux-64/${MY_PV}/chrome-linux.zip -> ${PN}-amd64-${MY_PV}.zip )"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND="media-fonts/corefonts
	>=sys-devel/gcc-4.2
	>=dev-libs/nspr-4.7
	>=dev-libs/nss-3.12
	gnome-base/gconf
	x11-libs/pango"

S=${WORKDIR}

QA_EXECSTACK="opt/chromium.org/chrome-linux/chrome"

# Ogg/Theora/Vorbis-only FFmpeg binaries
QA_TEXTRELS="opt/chromium.org/chrome-linux/libavcodec.so.52
	opt/chromium.org/chrome-linux/libavformat.so.52
	opt/chromium.org/chrome-linux/libavutil.so.50"
QA_PRESTRIPPED="opt/chromium.org/chrome-linux/libavcodec.so.52
	opt/chromium.org/chrome-linux/libavformat.so.52
	opt/chromium.org/chrome-linux/libavutil.so.50"

pkg_setup() {
	# Built with SSE2 enabled, so will fail on older processors
	if ! grep -q sse2 /proc/cpuinfo; then
		die "This binary requires SSE2 support, it will not work on older processors"
	fi
}

src_install() {
	declare CHROMIUM_HOME=/opt/chromium.org

	dodir ${CHROMIUM_HOME}
	cp -R chrome-linux/ "${D}"${CHROMIUM_HOME} || die "Unable to install chrome-linux folder"

	# Plugins symlink
	dosym /usr/$(get_libdir)/nsbrowser/plugins ${CHROMIUM_HOME}/chrome-linux/plugins

	# Create symlinks for needed libraries
	dodir ${CHROMIUM_HOME}/lib
	NSS_DIR=../../../usr/$(get_libdir)/nss
	NSPR_DIR=../../../usr/$(get_libdir)/nspr

	dosym ${NSPR_DIR}/libnspr4.so ${CHROMIUM_HOME}/lib/libnspr4.so.0d
	dosym ${NSPR_DIR}/libplc4.so ${CHROMIUM_HOME}/lib/libplc4.so.0d
	dosym ${NSPR_DIR}/libplds4.so ${CHROMIUM_HOME}/lib/libplds4.so.0d
	dosym ${NSS_DIR}/libnss3.so ${CHROMIUM_HOME}/lib/libnss3.so.1d
	dosym ${NSS_DIR}/libnssutil3.so ${CHROMIUM_HOME}/lib/libnssutil3.so.1d
	dosym ${NSS_DIR}/libsmime3.so ${CHROMIUM_HOME}/lib/libsmime3.so.1d
	dosym ${NSS_DIR}/libssl3.so ${CHROMIUM_HOME}/lib/libssl3.so.1d

	# Create chromium-bin wrapper
	make_wrapper chromium-bin ./chrome ${CHROMIUM_HOME}/chrome-linux ${CHROMIUM_HOME}/lib:${CHROMIUM_HOME}/chrome-linux
	newicon "${FILESDIR}"/chromium.png ${PN}.png
	make_desktop_entry chromium-bin "Chromium (bin)" ${PN}.png "Network;WebBrowser"
}

pkg_postinst() {
	ewarn "This binary requires the C++ runtime from >=sys-devel/gcc-4.2"
	ewarn "If you get the \"version \`GLIBCXX_3.4.9' not found\" error message,"
	ewarn "switch your active gcc to a version >=4.2 with gcc-config"
}
