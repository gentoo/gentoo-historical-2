# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/fwlogwatch/fwlogwatch-0.9.3.ebuild,v 1.4 2004/06/24 22:02:07 agriffis Exp $

DESCRIPTION="A packet filter and firewall log analyzer"
HOMEPAGE="http://cert.uni-stuttgart.de/projects/fwlogwatch/"
SRC_URI="http://www.kyb.uni-stuttgart.de/boris/sw/${P}.tar.gz"

KEYWORDS="x86 ~sparc"
LICENSE="GPL-1"
SLOT="0"
IUSE=""

DEPEND=">=sys-apps/sed-4"
RDEPEND=""

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i \
		-e "s/^CFLAGS = /CFLAGS = ${CFLAGS} /g" Makefile || \
			die "sed Makefile failed"
}

src_compile() {
	emake || die "emake failed"
}

src_install() {
	dosbin fwlogwatch
	dosbin contrib/fwlw_notify
	dosbin contrib/fwlw_respond
	dodir /usr/share/fwlogwatch/contrib
	insinto /usr/share/fwlogwatch/contrib
	doins contrib/fwlogsummary.cgi
	doins contrib/fwlogsummary_small.cgi
	doins contrib/fwlogwatch.php
	doins contrib
	insinto /etc
	doins fwlogwatch.config fwlogwatch.template
	dodoc AUTHORS ChangeLog CREDITS COPYING README
	doman fwlogwatch.8
}
