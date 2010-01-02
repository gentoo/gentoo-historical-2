# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/srf/srf-1.0.ebuild,v 1.4 2010/01/02 18:41:53 fauli Exp $

DESCRIPTION="The Simple Recursive Functions programming language"
HOMEPAGE="http://www.users.qwest.net/~eballen1/srf.html"
SRC_URI="http://www.users.qwest.net/~eballen1/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="sys-devel/flex
	|| ( sys-devel/bison dev-util/yacc dev-util/byacc )"
RDEPEND=""

src_install() {
	dobin srf rfunc/rfunc
	doman srf.1
	dodoc srf.html README
	docinto examples
	dodoc examples/*
}
