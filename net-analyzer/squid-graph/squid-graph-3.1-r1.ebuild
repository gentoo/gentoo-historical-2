# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/squid-graph/squid-graph-3.1-r1.ebuild,v 1.1 2005/05/17 12:24:50 ka0ttic Exp $

DESCRIPTION="Squid logfile analyzer and traffic grapher"
HOMEPAGE="http://squid-graph.securlogic.com/"
SRC_URI="http://squid-graph.securlogic.com/files/stable/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-perl/GD"

src_install () {
	dobin bin/apacheconv bin/generate.cgi bin/squid-graph bin/timeconv || \
		die "dobin failed"
	dodoc docs/CHANGELOG docs/README
	dohtml docs/html/*

	# install logo.png to a static location - bug 92668
	insinto /usr/share/${PN}
	doins docs/html/logo.png
}

pkg_postinst () {
	einfo
	einfo "Remember to copy /usr/share/${PN}/logo.png to your output directory"
	einfo
}


