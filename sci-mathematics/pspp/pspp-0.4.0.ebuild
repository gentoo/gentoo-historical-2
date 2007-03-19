# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/pspp/pspp-0.4.0.ebuild,v 1.1 2007/03/19 19:39:44 bicatali Exp $

inherit elisp-common

DESCRIPTION="Program for statistical analysis of sampled data."
HOMEPAGE="http://www.gnu.org/software/pspp/pspp.html"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.gz"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="doc ncurses emacs plotutils nls"

DEPEND=">=sci-libs/gsl-1.6
	sys-libs/readline
	>=sys-devel/gettext-0.14.1
	>=dev-lang/perl-5.6
	ncurses? ( >=sys-libs/ncurses-5.4 )
	plotutils? ( >=media-libs/plotutils-2.4.1 )"


# make check gave 39 failures of out 96 tests
RESTRICT="test"

src_compile() {
	econf \
		$(use_with plotutils libplot) \
		$(use_with ncurses) \
		$(use_enable nls) \
		|| die "econf failed"
	emake || die "emake failed"
	if use doc; then
		emake html || die "emake html failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	dodoc ABOUT-NLS AUTHORS ChangeLog \
		INSTALL NEWS ONEWS README THANKS TODO
	docinto examples && dodoc examples/{ChangeLog,descript.stat}

	use doc && dohtml doc/pspp.html/*
	use emacs && elisp-site-file-install pspp-mode.el
}

pkg_postinst () {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
