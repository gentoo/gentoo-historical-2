# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/jadetex/jadetex-3.13-r1.ebuild,v 1.9 2007/10/15 20:17:42 aballier Exp $

inherit latex-package

DESCRIPTION="TeX macros used by Jade TeX output"
HOMEPAGE="http://jadetex.sourceforge.net/"
SRC_URI="mirror://sourceforge/jadetex/${P}.tar.gz"

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE=""
RESTRICT="test"

DEPEND=">=app-text/openjade-1.3.1
	|| ( dev-texlive/texlive-fontsrecommended virtual/tetex )"

has_tetex_3() {
	if has_version '>=app-text/tetex-2.96' || has_version '>=app-text/ptex-3.1.4.20041026' || has_version '>=app-text/texlive-2005' || has_version '>=app-text/texlive-core-2007'; then
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

	make DESTDIR="${D}" install || die

	dodoc ChangeLog*
	doman *.1

	dodir /usr/bin
	if has_tetex_3 ; then
		dosym /usr/bin/latex /usr/bin/jadetex
		dosym /usr/bin/pdftex /usr/bin/pdfjadetex
		insinto /etc/texmf/texmf.d
		doins "${FILESDIR}"/80jadetex.cnf
	else
		dosym /usr/bin/virtex /usr/bin/jadetex
		dosym /usr/bin/pdfvirtex /usr/bin/pdfjadetex
	fi

	dohtml -r .
}

pkg_postinst() {
	if has_tetex_3 ; then
		texmf-update
		elog
		elog "If jadetex fails with \"TeX capacity exceeded, sorry [save size=5000]\","
		elog "increase save_size in /etc/texmf/texmf.d/80jadetex.cnf and."
		elog "remerge jadetex. See bug #21501."
		elog
	else
		latex-package_pkg_postinst
	fi
}

pkg_postrm() {
	if has_tetex_3 ; then
		texmf-update
	else
		latex-package_pkg_postrm
	fi
}
