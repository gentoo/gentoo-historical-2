# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/linuxdcpp/linuxdcpp-20071210.ebuild,v 1.1 2007/12/10 21:33:45 armin76 Exp $

inherit eutils

DESCRIPTION="Direct connect client, looks and works like famous DC++"
HOMEPAGE="http://linuxdcpp.berlios.de"
SRC_URI="ftp://ftp.berlios.de/pub/${PN}/${P}.tar.bz2
		mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE="debug"

RDEPEND=">=gnome-base/libglade-2.4
	>=x11-libs/gtk+-2.6
	app-arch/bzip2
	dev-libs/openssl"
DEPEND="${RDEPEND}
	media-libs/fontconfig
	>=dev-util/scons-0.96
	dev-util/pkgconfig"

src_compile() {
	local myconf=""
	use debug && myconf="${myconf} debug=1"

	scons ${myconf} ${MAKEOPTS} CXXFLAGS="${CXXFLAGS}" PREFIX=/usr || die "scons failed"
}

src_install() {
	insinto /usr/share/${PN}
	doins -r ${PN} pixmaps glade

	dodoc Readme.txt Changelog.txt Credits.txt

	dosym /usr/share/${PN}/${PN} /usr/bin/${PN}
	fperms +x /usr/share/${PN}/${PN}

	doicon pixmaps/${PN}.png

	make_desktop_entry ${PN} "${PN}" ${PN}.png
}

pkg_postinst() {
	elog
	elog "After adding first directory to shares you might need to restart linuxdcpp."
	elog
}
