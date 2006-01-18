# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/calamaris/calamaris-2.59.ebuild,v 1.5 2006/01/18 11:06:23 sekretarz Exp $

DESCRIPTION="Calamaris parses the logfiles of a wide variety of Web proxy servers and generates reports"
HOMEPAGE="http://calamaris.cord.de/"
SRC_URI="http://calamaris.cord.de/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"

DEPEND="dev-lang/perl"
IUSE=""

src_install () {
	dobin calamaris
	doman calamaris.1
	dodoc CHANGES EXAMPLES README
}
