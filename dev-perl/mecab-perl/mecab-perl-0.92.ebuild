# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/mecab-perl/mecab-perl-0.92.ebuild,v 1.1 2006/07/10 05:48:13 usata Exp $

inherit perl-module

DESCRIPTION="MeCab library module for Perl."
HOMEPAGE="http://www.daionet.gr.jp/~knok/chasen/"
SRC_URI="mirror://sourceforge.jp/mecab/20898/${P}.tar.gz"

SLOT="0"
LICENSE="|| ( GPL-2 LGPL-2.1 BSD )"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=app-text/mecab-${PV}"

src_test() {
	perl test.pl  || die "test.pl failed"
	perl test2.pl || die "test2.pl failed"
}

src_install() {
	perl-module_src_install || die "perl-module_src_install failed"
	dohtml bindings.html    || die "dohtml failed"
	dodoc test.pl test2.pl  || die "dodoc test{,2}.pl failed"
}
