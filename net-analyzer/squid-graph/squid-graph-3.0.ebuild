# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/squid-graph/squid-graph-3.0.ebuild,v 1.3 2002/12/09 04:33:09 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Squid logfile analyzer and traffic grapher"
HOMEPAGE="http://www.squid-graph.dhs.org"
SRC_URI="http://www.squid-graph.dhs.org/files/stable/${P}.tar"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="ppc x86 sparc "

DEPEND="dev-perl/GD"

src_install () {
	dobin bin/apacheconv bin/generate.cgi bin/squid-graph bin/timeconv
	dodoc docs/CHANGELOG docs/README
	dohtml docs/html/*
}

pkg_postinst () {
	einfo "Remember to copy /usr/share/doc/${P}/html/logo.png to your output directory"
}
