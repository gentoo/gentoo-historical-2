# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/linklint/linklint-2.3.5.ebuild,v 1.4 2006/11/05 19:37:54 dang Exp $

DESCRIPTION="Linklint is a Perl program that checks links on web sites."
HOMEPAGE="http://www.linklint.org/"
SRC_URI="http://www.linklint.org/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="dev-lang/perl"

src_install() {
	exeinto /usr/bin
	newexe ${P} linklint || die
	dodoc INSTALL.unix INSTALL.windows LICENSE.txt READ_ME.txt CHANGES.txt
	dohtml doc/*
}
