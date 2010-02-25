# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/txt2tags/txt2tags-2.5.ebuild,v 1.5 2010/02/25 07:48:08 jlec Exp $

EAPI="2"
PYTHON_USE_WITH="tk"
PYTHON_USE_WITH_OPT="tk"

inherit eutils elisp-common python

DESCRIPTION="A tool for generating marked up documents (HTML, SGML, ...) from a plain text file with markup"
HOMEPAGE="http://txt2tags.sourceforge.net/"
SRC_URI="mirror://sourceforge/txt2tags/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="emacs tk vim-syntax"

DEPEND="virtual/python
	tk? ( dev-lang/tk )
	vim-syntax? (
		|| (
			app-editors/vim
			app-editors/gvim
		)
	)
	emacs? ( virtual/emacs )"

RDEPEND="${DEPEND}"

SITEFILE="51${PN}-gentoo.el"

src_compile() {
	if use emacs; then
		elisp-compile extras/txt2tags-mode.el || die "elisp-compile failed"
	fi
}

src_install() {
	dobin txt2tags || die

	dodoc README TODO ChangeLog* || die
	insinto /usr/share/doc/${PF}
	doins doc/*.{pdf,t2t} || die
	# samples go into "samples" doc directory
	docinto samples
	dodoc samples/sample.* || die
	docinto samples/css
	dodoc samples/css/* || die
	docinto samples/img
	dodoc samples/img/* || die
	docinto samples/module
	dodoc samples/module/* || die
	# extras go into "extras" doc directory
	docinto extras
	dodoc extras/* || die
	newman doc/manpage.man txt2tags.1 || die

	# make .po files
	for pofile in "${S}"/po/*.po; do
		msgfmt -o ${pofile%%.po}.mo ${pofile}
	done
	domo po/*.mo

	# emacs support
	if use emacs; then
		elisp-install ${PN} extras/txt2tags-mode.{el,elc}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax/
		doins extras/txt2tags.vim || die

		echo 'au BufNewFile,BufRead *.t2t set ft=txt2tags' > "${T}/${PN}.vim"
		insinto /usr/share/vim/vimfiles/ftdetect
		doins "${T}/${PN}.vim" || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
