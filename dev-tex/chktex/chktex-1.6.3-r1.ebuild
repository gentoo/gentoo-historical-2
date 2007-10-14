# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/chktex/chktex-1.6.3-r1.ebuild,v 1.2 2007/10/14 20:40:42 aballier Exp $

DESCRIPTION="Checks latex source for common mistakes"
HOMEPAGE="http://baruch.ev-en.org/proj/chktex/"
SRC_URI="http://baruch.ev-en.org/proj/chktex/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug doc"

DEPEND="virtual/tetex
	dev-lang/perl
	sys-apps/groff
	doc? ( dev-tex/latex2html )"

src_compile() {
	econf `use_enable debug debug-info` || die
	emake || die
	if use doc ; then
		emake html || die "emake html failed"
	fi
}

src_install() {
	emake install DESTDIR="${D}" || die
	dodoc ChkTeX.readme NEWS
	if use doc ; then
		dohtml HTML/ChkTeX/*
		dodoc HTML/ChkTeX.tex
	fi
	doman chktex.1 chkweb.1
}
