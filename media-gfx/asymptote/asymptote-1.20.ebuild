# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/asymptote/asymptote-1.20.ebuild,v 1.2 2007/02/18 12:04:48 centic Exp $

inherit eutils elisp-common

DESCRIPTION="A vector graphics language that provides a framework for technical drawing"
HOMEPAGE="http://asymptote.sourceforge.net"
SRC_URI="mirror://sourceforge/asymptote/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"

IUSE="boehm-gc doc fftw emacs gsl vim-syntax"

RDEPEND=">=sys-libs/readline-4.3-r5
	>=sys-libs/ncurses-5.4-r5
	dev-libs/libsigsegv
	boehm-gc? ( >=dev-libs/boehm-gc-6.7 )
	virtual/tetex
	fftw? ( >=sci-libs/fftw-3.0.1 )
	emacs? ( virtual/emacs )
	gsl? ( sci-libs/gsl )
	vim? ( app-editors/vim )"
DEPEND="${RDEPEND}
	>=sys-devel/autoconf-2.5
	>=sys-devel/bison-1.875
	>=sys-devel/flex-2.5.4a-r5
	doc? ( >=media-gfx/imagemagick-6.1.3.2
		virtual/ghostscript
		>=sys-apps/texinfo-4.7-r1 )"

pkg_setup() {
	# checking if Boehm garbage collector was compiled with c++ support
	if use boehm-gc ; then
		if ! built_with_use dev-libs/boehm-gc nocxx ; then
			einfo "dev-libs/boehm-gc has been compiled with nocxx use flag disabled"
		else
			echo
			eerror "You have to rebuild dev-libs/boehm-gc enabling c++ support"
			die
		fi
	fi
}

src_unpack() {
	unpack ${A}

	cd ${S}

	# Fixing fftw and gsl enabling
	epatch ${FILESDIR}/${P}-configure-ac.patch
	einfo "Patching configure.ac"
	sed -i \
		-e "s:Datadir/doc/asymptote:Datadir/doc/${PF}:" \
		configure.ac || die "sed configure.ac failed"

	einfo "Building configure"
	WANT_AUTOCONF=2.5 autoconf

	epatch ${FILESDIR}/${P}-makefile.patch
}

src_compile() {
	for dir in `find /var/cache/fonts -type d`; do addwrite ${dir}; done

	myconf="--with-latex=/usr/share/texmf/tex/latex --disable-gc-debug"
	if use boehm-gc; then
		myconf="${myconf} --enable-gc=system"
	else
		myconf="${myconf} --disable-gc"
	fi

	econf ${myconf} $(use_with fftw) $(use_with gsl) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	for dir in `find /var/cache/fonts -type d`; do addwrite ${dir}; done

	if use doc; then
		target="install-all"
	else
		target="install"
	fi

	make DESTDIR=${D} ${target} || die "make install failed"

	dodoc BUGS ChangeLog README ReleaseNotes TODO

	if use emacs ; then
		elisp-site-file-install base/asy-mode.el
		elisp-site-file-install "${FILESDIR}"/64asy-gentoo.el
	fi

	if use vim-syntax ; then
		insinto /usr/share/vim/vimfiles/syntax
		doins base/asy.vim
	fi
}

pkg_postinst() {
	einfo 'Updating TeX tree...'
	texhash &> /dev/null

	einfo 'Use the variable ASYMPTOTE_PSVIEWER to set the postscript viewer'
	einfo 'Use the variable ASYMPTOTE_PDFVIEWER to set the PDF viewer'

	use emacs && elisp-site-regen
}

pkg_postrm() {
	einfo 'Updating TeX tree...'
	texhash &> /dev/null

	[ -f "${SITELISP}"/site-gentoo.el ] && elisp-site-regen
}
