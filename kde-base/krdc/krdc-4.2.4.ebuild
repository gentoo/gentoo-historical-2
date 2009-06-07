# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/krdc/krdc-4.2.4.ebuild,v 1.4 2009/06/07 02:52:35 jmbsvicetto Exp $

EAPI="2"

KMNAME="kdenetwork"
inherit kde4-meta

DESCRIPTION="KDE remote desktop connection (RDP and VNC) client"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="debug +handbook jpeg vnc zeroconf"

#nx? ( >=net-misc/nxcl-0.9-r1 ) doesnt work atm
#sed -e '72,74d' -i ${WORKDIR}/krdc_build/krdc/cmake_install.cmake || die "sed failed" #nomachine default key isnt there, doesnt matter

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
RDEPEND="${DEPEND}"

src_compile() {
	mycmakeargs="${mycmakeargs}
		$(cmake-utils_use_with jpeg JPEG)
		$(cmake-utils_use_with vnc LibVNCServer)
		$(cmake-utils_use_with zeroconf DNSSD)"

	kde4-meta_src_compile
}

pkg_postinst() {
	elog "If you want to use the remote desktop protocol (RDP) install net-misc/rdesktop"
}
