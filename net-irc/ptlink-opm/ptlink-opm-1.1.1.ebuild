# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/ptlink-opm/ptlink-opm-1.1.1.ebuild,v 1.1 2004/07/10 22:50:41 swegener Exp $

MY_P="PTlink.OPM${PV}"

DESCRIPTION="PTlink Open Proxy Monitor"
HOMEPAGE="http://www.ptlink.net/"
SRC_URI="mirror://sourceforge/ptlinksoft/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=""

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	sed -i \
		-e 's:ptopm\.dconf:/etc/ptlink-opm/ptopm.dconf:' \
		-e 's:ptopm\.log:log/ptopm.log:' \
		${S}/src/ptopm.c
}

src_compile() {
	econf || die "econf failed"

	# Now we're going to override the paths setup by configure
	echo "#define BPATH \"/usr/bin\"" > include/path.h
	echo "#define DPATH \"/var/lib/ptlink-opm\"" >> include/path.h

	emake || die "emake failed"
}

src_install() {
	newbin src/ptopm ptlink-opm

	keepdir /var/{lib,log}/ptlink-opm
	dosym /var/log/ptlink-opm /var/lib/ptlink-opm/log

	insinto /etc/ptlink-opm
	newins samples/ptopm.dconf.sample ptopm.dconf

	dodoc CHANGES README

	exeinto /etc/init.d
	newexe ${FILESDIR}/ptlink-opm.init.d ptlink-opm
	insinto /etc/conf.d
	newins ${FILESDIR}/ptlink-opm.conf.d ptlink-opm
}

pkg_postinst() {
	enewuser ptlink-opm
	chown ptlink-opm ${ROOT}/var/{log,lib}/ptlink-opm
}
