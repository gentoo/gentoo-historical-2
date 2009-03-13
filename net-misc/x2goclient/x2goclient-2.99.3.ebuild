# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/x2goclient/x2goclient-2.99.3.ebuild,v 1.1 2009/03/13 12:36:03 voyageur Exp $

EAPI="2"
inherit qt4 versionator

MAJOR_PV="$(get_version_component_range 1-2)"
FULL_PV="${MAJOR_PV}-$(get_version_component_range 3)"
DESCRIPTION="The X2Go Qt client"
HOMEPAGE="http://x2go.berlios.de"
SRC_URI="http://x2go.obviously-nice.de/deb/pool-lenny/${PN}/${PN}_${FULL_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ldap"

DEPEND="net-misc/nx
	|| ( ( x11-libs/qt-core:4 x11-libs/qt-gui:4 x11-libs/qt-svg:4 )
		>=x11-libs/qt-4.3:4 )
	ldap? ( net-nds/openldap )"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-${MAJOR_PV}

src_prepare() {
	use ldap ||	epatch "${FILESDIR}"/${PN}-2.0.1-noldap.patch
}

src_compile() {
	eqmake4
	emake || die "emake failed"
}

src_install() {
	dobin ${PN}
	dodoc README
}
