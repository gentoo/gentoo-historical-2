# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmtime/wmtime-1.0_beta2_p9.ebuild,v 1.1 2008/04/11 09:44:24 s4t4n Exp $

inherit eutils versionator

MY_PV="$(get_version_component_range 1-2)"
MY_PL="$(get_version_component_range 3)"
MY_PL="${MY_PL/beta/b}"
MY_PV="${MY_PV}${MY_PL}"
MY_PL="$(get_version_component_range 4)"
MY_PL="${MY_PL/p/}"

IUSE=""

DESCRIPTION="applet which displays the date and time in a dockable tile"
SRC_URI="http://ftp.debian.org/debian/pool/main/w/wmtime/wmtime_${MY_PV}.orig.tar.gz
	http://ftp.debian.org/debian/pool/main/w/wmtime/wmtime_${MY_PV}-${MY_PL}.diff.gz"
HOMEPAGE="http://packages.qa.debian.org/w/wmtime.html"

SLOT="0"
KEYWORDS="~x86"
LICENSE="GPL-2"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXpm"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
	>=sys-apps/sed-4"

S="${WORKDIR}/${PN}-${MY_PV}.orig/${PN}"

src_unpack() {
	unpack ${A}
	cd "${WORKDIR}"

	# apply debian patch
	epatch "${PN}_${MY_PV}-${MY_PL}.diff"
}

src_compile() {
	emake CFLAGS="${CFLAGS}" || die "emake failed"
}

src_install () {
	dobin wmtime
	doman wmtime.1

	cd ..
	dodoc BUGS CHANGES HINTS README TODO

	# install sample config file, too
	dodoc debian/wmtimerc
}
