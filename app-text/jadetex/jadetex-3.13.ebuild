# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/jadetex/jadetex-3.13.ebuild,v 1.10 2005/04/08 14:24:52 corsair Exp $

inherit latex-package

DESCRIPTION="TeX macros used by Jade TeX output"
HOMEPAGE="http://jadetex.sourceforge.net/"
SRC_URI="mirror://sourceforge/jadetex/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha ~amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE=""

# virtual/tetex comes from latex-package
DEPEND=">=app-text/openjade-1.3.1"

has_tetex_3() {
	if has_version '>=app-text/tetex-2.96' || has_version '>=app-text/ptex-3.1.4.20041026' ; then
		true
	else
		false
	fi
}

src_compile() {
	addwrite /usr/share/texmf/ls-R
	addwrite /usr/share/texmf/fonts
	addwrite /var/cache/fonts

	if has_tetex_3 ; then
		sed -i -e "s:tex -ini:latex -ini:" Makefile || die "sed failed"
	fi

	emake || die
}

src_install() {
	addwrite /usr/share/texmf/ls-R
	addwrite /usr/share/texmf/fonts
	addwrite /var/cache/fonts
	make \
		DESTDIR=${D} \
		install || die

	dodoc ChangeLog*
	doman *.1

	dodir /usr/bin
	if has_tetex_3 ; then
		dosym /usr/bin/latex /usr/bin/jadetex
		dosym /usr/bin/pdftex /usr/bin/pdfjadetex
	else
		dosym /usr/bin/virtex /usr/bin/jadetex
		dosym /usr/bin/pdfvirtex /usr/bin/pdfjadetex
	fi

	dohtml -r doc/*
}
