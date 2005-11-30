# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/linklint/linklint-2.3.4.ebuild,v 1.1.1.1 2005/11/30 10:04:50 chriswhite Exp $

DESCRIPTION="Linklint is a Perl program that checks links on web sites."
HOMEPAGE="http://www.linklint.org/"
SRC_URI="http://www.linklint.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc"
IUSE=""

DEPEND="dev-lang/perl"

src_install() {
	exeinto /usr/bin
	newexe ${P} linklint || die
	dodoc INSTALL.unix INSTALL.windows LICENSE.txt READ_ME.txt CHANGES.txt
	dohtml doc/*
}
