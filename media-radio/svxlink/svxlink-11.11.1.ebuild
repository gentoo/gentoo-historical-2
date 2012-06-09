# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-radio/svxlink/svxlink-11.11.1.ebuild,v 1.3 2012/06/09 00:30:51 zmedico Exp $

EAPI=4
inherit eutils multilib qt4-r2 user

DESCRIPTION="Multi Purpose Voice Services System, including Qtel for EchoLink"
HOMEPAGE="http://svxlink.sourceforge.net/"
SRC_URI="mirror://sourceforge/svxlink/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-lang/tcl
	x11-libs/qt-core
	x11-libs/qt-gui
	media-libs/alsa-lib
	media-sound/gsm
	dev-libs/libgcrypt
	media-libs/speex
	dev-libs/libsigc++:1.2
	dev-libs/popt"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	enewgroup svxlink
	enewuser svxlink -1 -1 -1 svxlink
}

src_prepare() {
	sed -i -e "s:/lib:/$(get_libdir):g" makefile.cfg || die
	sed -i -e "s:/etc/udev:/lib/udev:" svxlink/scripts/Makefile.default || die
	# fix underlinking
	sed -i -e "s:lgsm:lgsm -lspeex:" qtel/Makefile.default || die
}

src_install() {
	default

	fowners -R svxlink.svxlink /var/spool/svxlink
	# adapt to gentoo init system
	rm -R "${D}"/etc/sysconfig || die
	newinitd "${FILESDIR}"/remotetrx.init remotetrx
	newinitd "${FILESDIR}"/svxlink.init svxlink
	newconfd "${FILESDIR}"/remotetrx.rc remotetrx
	newconfd "${FILESDIR}"/svxlink.rc svxlink
}
