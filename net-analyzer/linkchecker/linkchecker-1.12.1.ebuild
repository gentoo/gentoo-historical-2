# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/linkchecker/linkchecker-1.12.1.ebuild,v 1.3 2004/06/24 22:06:53 agriffis Exp $

IUSE=""

inherit distutils

LICENSE="GPL-2"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
HOMEPAGE="http://linkchecker.sourceforge.net/"
DESCRIPTION="LinkChecker can check HTML documents for broken links."
KEYWORDS="~x86 ~ppc"
RESTRICT="nomirror"
SLOT=0

DEPEND=">=dev-lang/python-2.3.3"
