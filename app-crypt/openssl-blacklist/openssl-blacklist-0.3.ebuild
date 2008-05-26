# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/openssl-blacklist/openssl-blacklist-0.3.ebuild,v 1.1 2008/05/26 22:40:11 hanno Exp $

DESCRIPTION="Detection of weak ssl keys produced by certain debian versions between 2006 and 2008"
HOMEPAGE="https://launchpad.net/ubuntu/+source/openssl-blacklist/"
SRC_URI="https://launchpad.net/ubuntu/intrepid/+source/openssl-blacklist/${PV}/+files/${PN}_${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE=""
DEPEND="dev-lang/python"

src_compile() {
	einfo nothing to compile
}

src_install() {
	dobin openssl-vulnkey || die "dobin failed"
	doman openssl-vulnkey.1 || die "doman failed"
	insinto /usr/share/openssl-blacklist/
	doins blacklist.RSA-* || die "installing blacklist failed"
}
