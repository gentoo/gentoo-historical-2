# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/scanssh/scanssh-1.6b.ebuild,v 1.7 2004/06/24 22:17:43 agriffis Exp $

S=${WORKDIR}/scanssh
DESCRIPTION="scanssh protocol scanner scans a list of addresses an networks for running SSH protocol servers and their version numbers."
SRC_URI="http://monkey.org/~provos/${P}.tar.gz"
HOMEPAGE="http://monkey.org/~provos/scanssh/"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86 ~ppc ~sparc"
IUSE=""

DEPEND="net-libs/libpcap"

src_install() {
	doman scanssh.1
	dobin scanssh
}
