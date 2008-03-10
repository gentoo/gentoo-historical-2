# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdnssd/kdnssd-4.0.2.ebuild,v 1.1 2008/03/10 23:37:28 philantrop Exp $

EAPI="1"

KMNAME=kdenetwork
inherit kde4-meta

DESCRIPTION="A DNSSD (DNS Service Discovery - part of Rendezvous) ioslave and kded module"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="|| ( net-dns/avahi net-misc/mDNSResponder )"
RDEPEND="${DEPEND}"

pkg_setup() {
	if has_version net-dns/avahi; then
		KDE4_BUILT_WITH_USE_CHECK="
			${KDE4_BUILT_WITH_USE_CHECK} net-dns/avahi mdnsresponder-compat"
	fi
	kde4-meta_pkg_setup
}

src_compile() {
	mycmakeargs="${mycmakeargs} -DWITH_Xmms=OFF -DWITH_DNSSD=ON"

	kde4-meta_src_compile
}
