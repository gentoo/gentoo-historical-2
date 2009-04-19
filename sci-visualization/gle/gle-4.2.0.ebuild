# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/gle/gle-4.2.0.ebuild,v 1.1 2009/04/19 14:38:18 grozin Exp $
EAPI=1
inherit eutils elisp-common qt4
MY_P=GLE-${PV}
DESCRIPTION="Graphics Layout Engine"
HOMEPAGE="http://glx.sourceforge.net/"
SRC_URI="mirror://sourceforge/glx/${MY_P}-src.zip
	doc? ( mirror://sourceforge/glx/${PN}-manual-${PV}.pdf
		   mirror://sourceforge/glx/GLEusersguide.pdf )"
SLOT="0"
LICENSE="BSD emacs? ( GPL-2 )"
KEYWORDS="~amd64 ~x86"
IUSE="X qt4 jpeg png tiff doc emacs vim-syntax"

CDEPEND="sys-libs/ncurses
	X? ( x11-libs/libX11 )
	qt4? ( || ( x11-libs/qt-gui:4 =x11-libs/qt-4.3*:4 ) )
	jpeg? ( media-libs/jpeg )
	png? ( media-libs/libpng )
	tiff? ( media-libs/tiff )
	emacs? ( virtual/emacs )"

DEPEND="${CDEPEND}
	app-arch/unzip"

RDEPEND="${CDEPEND}
	virtual/ghostscript
	virtual/latex-base
	vim-syntax? ( || ( app-editors/vim app-editors/gvim ) )"

S="${WORKDIR}"/${PN}4

src_compile() {
	econf $(use_with qt4 qt /usr) \
		$(use_with X x) \
		$(use_with jpeg) \
		$(use_with png) \
		$(use_with tiff)

	# emake failed in src/gui (probably qmake stuff)
	emake -j1 || die "emake failed"

	if use emacs; then
		cd contrib/editors/highlighting
		mv ${PN}-emacs.el ${PN}-mode.el
		elisp-compile ${PN}-mode.el || die
	fi
}

src_install() {
	# -jN failed to install some data files
	emake -j1 DESTDIR="${D}" install || die "emake install failed"
	dodoc README.txt

	if use qt4; then
		newicon src/gui/images/gle_icon.png gle.png
		make_desktop_entry qgle GLE gle
		newdoc src/gui/readme.txt gui_readme.txt
	fi

	if use doc; then
		insinto /usr/share/doc/${PF}
		doins "${DISTDIR}"/${PN}-manual-${PV}.pdf \
			"${DISTDIR}"/GLEusersguide.pdf
	fi

	if use emacs; then
		elisp-install ${PN} contrib/editors/highlighting/gle-mode.{el,elc} || die
		elisp-site-file-install "${FILESDIR}"/64gle-gentoo.el || die
	fi

	if use vim-syntax ; then
		dodir /usr/share/vim/vimfiles/ftplugins \
			/usr/share/vim/vimfiles/indent \
			/usr/share/vim/vimfiles/syntax
		cd contrib/editors/highlighting/vim
		chmod 644 ftplugin/* indent/* syntax/*
		insinto /usr/share/vim/vimfiles/ftplugins
		doins ftplugin/* || die
		insinto /usr/share/vim/vimfiles/indent
		doins indent/* || die
		insinto /usr/share/vim/vimfiles/syntax
		doins syntax/* || die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
