# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/suikyo/suikyo-2.1.0.ebuild,v 1.1 2005/03/30 04:43:40 usata Exp $

inherit ruby elisp-common

MY_P=${P/_/-}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Romaji Hiragana conversion library"
HOMEPAGE="http://taiyaki.org/suikyo/"
SRC_URI="http://prime.sourceforge.jp/src/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~ppc ~x86 ~ppc64"
IUSE="emacs"

DEPEND="emacs? ( virtual/emacs )"

RUBY_ECONF="--with-suikyo-docdir=/usr/share/doc/${PF}/html
	--with-rubydir=/usr/lib/ruby/site_ruby"

src_install() {
	einstall || die
	erubydoc

	use emacs || rm -rf ${D}/usr/share/emacs/
	use emacs && elisp-site-file-install ${FILESDIR}/50suikyo-gentoo.el
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
