# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-wireless/chillispot/chillispot-1.0.ebuild,v 1.4 2006/03/10 01:06:19 agriffis Exp $

inherit eutils flag-o-matic gnuconfig

DESCRIPTION="ChilliSpot is an open source captive portal or wireless LAN access point controller."
HOMEPAGE="http://www.chillispot.org"
SRC_URI="http://www.chillispot.org/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ia64 ~mips ~ppc ~s390 ~sparc x86"
IUSE=""

DEPEND="virtual/libc >=sys-apps/sed-4"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}
	gnuconfig_update
	chmod 644 doc/*.conf
	find . -exec chmod go-w '{}' \;
}

src_compile() {
	export CFLAGS
	econf || die "FAILED: econf"
	emake || die "FAILED: emake"
}

src_install() {
	einstall || die "einstall failed"
	cd doc && dodoc chilli.conf freeradius.users hotspotlogin.cgi firewall.iptables

	# init script provided by Michele Beltrame bug #124698
	dodir /etc/init.d
	exeinto /etc/init.d
	newexe "${FILESDIR}"/${PN} ${PN}
}
