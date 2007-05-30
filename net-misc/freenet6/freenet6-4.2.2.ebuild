# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/freenet6/freenet6-4.2.2.ebuild,v 1.5 2007/05/30 13:18:16 gustavoz Exp $

inherit eutils versionator

MY_PV=$(replace_all_version_separators "_")
DESCRIPTION="Client to configure an IPv6 tunnel to freenet6"
HOMEPAGE="http://www.freenet6.net/"
SRC_URI="mirror://gentoo/gw6c${MY_PV}src.tar.gz"

LICENSE="VPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~hppa sparc ~x86"
IUSE=""

DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"

S="${WORKDIR}/tspc-advanced"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-noretry.patch
}

src_compile() {
	emake all target=linux || die "Build Failed"
}

src_install() {
	dosbin bin/gw6c

	insopts -m 600
	insinto /etc/freenet6
	doins ${FILESDIR}/gw6c.conf
	exeinto /etc/freenet6/template
	doexe template/{linux,checktunnel}.sh

	newinitd ${FILESDIR}/gw6c.rc gw6c

	doman man/{man5/gw6c.conf.5,man8/gw6c.8}
}

pkg_postinst() {
	if has_version '=net-misc/freenet6-1*' ; then
		ewarn "Warning: you are upgrading from an older version"
		ewarn "The configuration file has been renamed to gw6c.conf"
		ewarn "Remember to port your personal settings from tspc.conf to it"
		ewarn "The init script has been renamed to 'gw6c',"
	else
		elog "The freenet6 ebuild installs an init script named 'gw6c'"
	fi
	elog "to coincide with the name of the client binary installed"
	elog "To add support for a freenet6 connection at startup, do"
	elog ""
	elog "# rc-update add gw6c default"
}
