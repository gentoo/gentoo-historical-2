# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/bsign/bsign-0.4.5.ebuild,v 1.5 2004/05/22 00:26:05 vapier Exp $

DESCRIPTION="embed secure hashes (SHA1) and digital signatures (GNU Privacy Guard) into files"
HOMEPAGE="http://packages.debian.org/unstable/admin/bsign.html"
SRC_URI="mirror://debian/pool/main/b/bsign/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

DEPEND=""
RDEPEND=""

src_install() {
	dobin bsign bsign_sign bsign_verify bsign_hash bsign_check || die
	doman bsign.1
}
