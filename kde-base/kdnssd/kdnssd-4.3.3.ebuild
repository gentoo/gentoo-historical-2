# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdnssd/kdnssd-4.3.3.ebuild,v 1.2 2009/11/29 15:02:29 ssuominen Exp $

EAPI="2"

KMNAME="kdenetwork"
inherit kde4-meta

DESCRIPTION="A DNSSD (DNS Service Discovery - part of Rendezvous) ioslave and kded module"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug zeroconf"

DEPEND="
	zeroconf? ( $(add_kdebase_dep kdelibs zeroconf) )
"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs="${mycmakeargs} -DWITH_Xmms=OFF -DWITH_DNSSD=ON"

	kde4-meta_src_configure
}
