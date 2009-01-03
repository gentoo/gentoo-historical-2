# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xosview/xosview-1.8.3.ebuild,v 1.11 2009/01/03 16:27:21 halcy0n Exp $

inherit eutils

DESCRIPTION="X11 operating system viewer"
HOMEPAGE="http://xosview.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""

COMMON_DEPS="x11-libs/libX11
	x11-libs/libXpm
	x11-libs/libXt"

RDEPEND="${COMMON_DEPS}
	media-fonts/font-misc-misc"
DEPEND="${COMMON_DEPS}
	x11-proto/xproto"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/xosview-emptyxpaths.patch"
	epatch "${FILESDIR}/xosview-resdir.patch"
	epatch "${FILESDIR}/${P}-remove-serialmeter.patch"
}

src_install() {
	exeinto /usr/bin
	doexe xosview
	insinto /etc/X11/app-defaults
	newins Xdefaults XOsview
	doman *.1
	dodoc CHANGES README README.linux TODO
}
