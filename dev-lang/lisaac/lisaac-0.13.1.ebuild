# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/lisaac/lisaac-0.13.1.ebuild,v 1.1 2008/03/01 16:44:34 philantrop Exp $

inherit versionator elisp-common

DESCRIPTION="Lisaac is an object prototype based language"
HOMEPAGE="http://isaacproject.u-strasbg.fr/li.html"
SRC_URI="http://isaacproject.u-strasbg.fr/download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="vim emacs kde examples"

DEPEND="vim? ( app-editors/vim )
		emacs? ( virtual/emacs )
		kde? ( || ( =kde-base/kate-3.5* =kde-base/kdebase-3.5* ) )"

RDEPEND="${DEPEND}"

SITEFILE=50${PN}-gentoo.el

src_compile(){
	emake || die "emake failed"

	if use emacs; then
		elisp-compile editor/emacs/lisaac-mode.el \
			|| die "compiling emacs component failed."
	fi
}

src_install(){
	emake DESTDIR="${D}" install || die "install failed"

	if use vim; then
		insinto /usr/share/vim/vimfiles/syntax/
		doins editor/vim/syntax/lisaac.vim
		insinto /usr/share/vim/vimfiles/indent/
		doins editor/vim/indent/lisaac.vim
	fi

	if use emacs; then
		elisp-install ${PN} editor/emacs/*.{el,elc} \
			|| die "installing emacs coponent failed."
		elisp-site-file-install "${FILESDIR}"/${SITEFILE} \
			|| die "installing emacs site file failed"
	fi

	if use kde; then
		insinto /usr/share/apps/katepart/syntax/
		doins editor/kate/lisaac_v2.xml
	fi

	if use examples; then
		dodir /usr/share/${PN}/
		cp -r example "${D}"/usr/share/${PN}/examples
	fi
}

pkg_postinst(){
	if use vim; then
		elog "Add the following line to your vimrc if you want"
		elog "to enable the lisaac support :"
		elog
		elog "au BufNewFile,BufRead *.li setf lisaac"
	fi

	use emacs && elisp-site-regen
}

pkg_postrm(){
	use emacs && elisp-site-regen
}
