# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krdc/krdc-4.4.5-r1.ebuild,v 1.2 2010/11/08 23:26:49 jmbsvicetto Exp $

EAPI="3"

KMNAME="kdenetwork"
inherit kde4-meta

DESCRIPTION="KDE remote desktop connection (RDP and VNC) client"
KEYWORDS="amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook jpeg rdp vnc zeroconf"

#nx? ( >=net-misc/nxcl-0.9-r1 ) disabled upstream, last checked 4.3.61
#telepathy? ( >=net-libs/telepathy-qt4-0.18 ) not yet in portage/overlay

DEPEND="
	jpeg? ( media-libs/jpeg )
	vnc? ( >=net-libs/libvncserver-0.9 )
	zeroconf? (
		|| (
			net-dns/avahi
			net-misc/mDNSResponder
		)
	)
"
RDEPEND="${DEPEND}
	rdp? ( net-misc/rdesktop )
"

src_configure() {
	mycmakeargs=(
		-DWITH_TelepathyQt4=OFF
		$(cmake-utils_use_with jpeg)
		# $(cmake-utils_use_with telepathy TelepathyQt4)
		$(cmake-utils_use_with vnc LibVNCServer)
		$(cmake-utils_use_with zeroconf DNSSD)
	)

	kde4-meta_src_configure
}
