# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krfb/krfb-4.3.3.ebuild,v 1.1 2009/11/02 21:37:16 wired Exp $

EAPI="2"

KMNAME="kdenetwork"
inherit kde4-meta

DESCRIPTION="VNC-compatible server to share KDE desktops"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug +handbook zeroconf"

DEPEND="
	>=net-libs/libvncserver-0.9
	net-libs/openslp
	x11-libs/libXdamage
	zeroconf? (
		|| (
			net-dns/avahi[mdnsresponder-compat]
			net-misc/mDNSResponder
		)
	)
"
RDEPEND="${DEPEND}"

src_configure() {
	# krfb requires both slp and vnc to build
	mycmakeargs="${mycmakeargs}
		-DWITH_Xmms=OFF -DWITH_SLP=ON -DWITH_LibVNCServer=ON
		$(cmake-utils_use_with zeroconf DNSSD)"

	kde4-meta_src_configure
}
