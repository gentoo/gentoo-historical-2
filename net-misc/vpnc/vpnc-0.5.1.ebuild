# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vpnc/vpnc-0.5.1.ebuild,v 1.7 2007/11/14 05:53:42 opfer Exp $

inherit linux-info

DESCRIPTION="Free client for Cisco VPN routing software"
HOMEPAGE="http://www.unix-ag.uni-kl.de/~massar/vpnc/"
SRC_URI="http://www.unix-ag.uni-kl.de/~massar/${PN}/${P}.tar.gz"

LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE="hybrid-auth bindist"

DEPEND=">=dev-libs/libgcrypt-1.1.91
	>=sys-apps/iproute2-2.6.19.20061214
	!bindist? ( hybrid-auth? ( dev-libs/openssl ) )"

RDEPEND="${DEPEND}
	resolvconf? ( net-dns/resolvconf-gentoo )"

pkg_setup()	 {
	if use hybrid-auth && use bindist; then
		ewarn "Hybrid authentication will be disabled for this packages as you will"
		ewarn "redistribute it in binary form.  This is not allowed due to linking"
		ewarn "of OpenSSL."
	fi
	local CONFIG_CHECK="TUN"
	check_extra_config
}

src_compile() {
	# is reported upstream and fixed in next version
	sed -e "s:/usr/local:/usr:" -i vpnc-script
	# only allowed if not distributed in binary form!
	if use hybrid-auth && ! use bindist; then
		hybridauthopts="OPENSSL_GPL_VIOLATION=-DOPENSSL_GPL_VIOLATION OPENSSLLIBS=-lcrypto"
	fi
	emake ${hybridauthopts} || die "emake failed"
}

src_install() {
	emake PREFIX="/usr" DESTDIR="${D}" install || die "emake install failed"
	dodoc README TODO VERSION
	keepdir /var/run/vpnc
	newinitd "${FILESDIR}/vpnc-1.init" vpnc
	newconfd "${FILESDIR}/vpnc.confd" vpnc
}

pkg_postinst() {
	elog "You can generate a configuration file from the original Cisco profiles of your"
	elog "connection by using /usr/bin/pcf2vpnc to convert the .pcf file"
	elog "A guide is to be found in http://www.gentoo.org/doc/en/vpnc-howto.xml"
}
