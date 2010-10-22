# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-visualization/gnuplot/gnuplot-4.4.2.ebuild,v 1.3 2010/10/22 17:34:14 hwoarang Exp $

EAPI=3

inherit elisp-common multilib wxwidgets

MY_P="${P/_/-}"
DESCRIPTION="Command-line driven interactive plotting program"
HOMEPAGE="http://www.gnuplot.info/"
SRC_URI="mirror://sourceforge/gnuplot/${MY_P}.tar.gz"

LICENSE="gnuplot GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="cairo doc emacs +gd ggi latex lua pdf plotutils readline svga thin-splines wxwidgets X xemacs"

RESTRICT="wxwidgets? ( test )"

RDEPEND="!app-emacs/gnuplot-mode
	cairo? ( x11-libs/cairo
		x11-libs/pango
		>=x11-libs/gtk+-2.8 )
	emacs? ( virtual/emacs )
	gd? ( media-libs/gd[png] )
	ggi? ( media-libs/libggi )
	latex? ( virtual/latex-base
		lua? ( dev-tex/pgf
			>=dev-texlive/texlive-latexrecommended-2008-r2 ) )
	lua? ( dev-lang/lua )
	pdf? ( media-libs/pdflib )
	plotutils? ( media-libs/plotutils )
	readline? ( sys-libs/readline )
	svga? ( media-libs/svgalib )
	wxwidgets? ( x11-libs/wxGTK:2.8[X]
		x11-libs/cairo
		x11-libs/pango
		>=x11-libs/gtk+-2.8 )
	X? ( x11-libs/libXaw )
	xemacs? ( app-editors/xemacs
		app-xemacs/xemacs-base
		app-xemacs/texinfo )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( virtual/latex-base
		app-text/ghostscript-gpl )"

S="${WORKDIR}/${MY_P}"
GP_VERSION="${PV%.*}"
E_SITEFILE="50${PN}-gentoo.el"
TEXMF="${EPREFIX}/usr/share/texmf-site"

src_prepare() {
	# Add special version identification as required by provision 2
	# of the gnuplot license
	sed -i -e "1s/.*/& (Gentoo revision ${PR})/" PATCHLEVEL || die
}

src_configure() {
	if ! use latex; then
		sed -i -e '/SUBDIRS/s/LaTeX//' share/Makefile.in || die
	fi

	if use wxwidgets; then
		WX_GTK_VER="2.8"
		need-wxwidgets unicode
	fi

	local myconf
	myconf="${myconf} --without-lisp-files"
	myconf="${myconf} --with-texdir=${TEXMF}/tex/latex/${PN}"
	myconf="${myconf} $(use_with cairo)"
	myconf="${myconf} $(use_with doc tutorial)"
	myconf="${myconf} $(use_with gd)"
	myconf="${myconf} $(use_with ggi ggi ${EPREFIX}/usr/$(get_libdir))"
	myconf="${myconf} $(use_with ggi xmi ${EPREFIX}/usr/$(get_libdir))"
	myconf="${myconf} $(use_with lua)"
	myconf="${myconf} $(use_with pdf pdf "${EPREFIX}"/usr/$(get_libdir))"
	myconf="${myconf} $(use_with plotutils plot "${EPREFIX}"/usr/$(get_libdir))"
	myconf="${myconf} $(use_with svga linux-vga)"
	myconf="${myconf} $(use_enable thin-splines)"
	myconf="${myconf} $(use_enable wxwidgets)"
	myconf="${myconf} $(use_with X x)"
	use readline \
		&& myconf="${myconf} --with-readline=gnu" \
		|| myconf="${myconf} --with-readline=builtin"

	econf ${myconf} DIST_CONTACT="http://bugs.gentoo.org/"

	if use xemacs; then
		einfo "Configuring gnuplot-mode for XEmacs ..."
		use emacs && cp -Rp lisp lisp-xemacs || ln -s lisp lisp-xemacs
		cd "${S}/lisp-xemacs"
		econf --with-lispdir="${EPREFIX}/usr/lib/xemacs/site-packages/${PN}" EMACS=xemacs
	fi

	if use emacs; then
		einfo "Configuring gnuplot-mode for GNU Emacs ..."
		cd "${S}/lisp"
		econf --with-lispdir="${EPREFIX}${SITELISP}/${PN}" EMACS=emacs
	fi
}

src_compile() {
	# Prevent access violations, see bug 201871
	VARTEXFONTS="${T}/fonts"

	# This is a hack to avoid sandbox violations when using the Linux console.
	# Creating the DVI and PDF tutorials require /dev/svga to build the
	# example plots.
	addwrite /dev/svga:/dev/mouse:/dev/tts/0

	emake || die

	if use xemacs; then
		cd "${S}/lisp-xemacs"
		emake || die
	fi

	if use emacs; then
		cd "${S}/lisp"
		emake || die
	fi

	if use doc; then
		# Avoid sandbox violation in epstopdf/ghostscript
		addpredict /var/cache/fontconfig
		cd "${S}/docs"
		emake pdf || die
		cd "${S}/tutorial"
		emake pdf || die

		if use emacs || use xemacs; then
			cd "${S}/lisp"
			emake pdf || die
		fi
	fi
}

src_install () {
	emake DESTDIR="${D}" install || die

	if use xemacs; then
		cd "${S}/lisp-xemacs"
		emake DESTDIR="${D}" install || die
	fi

	if use emacs; then
		cd "${S}/lisp"
		emake DESTDIR="${D}" install || die
		# info-look* is included with >=emacs-21
		rm -f "${ED}${SITELISP}/${PN}"/info-look*

		# Gentoo emacs site-lisp configuration
		echo "(add-to-list 'load-path \"@SITELISP@\")" > ${E_SITEFILE}
		sed '/^;; move/,+3 d' dotemacs >> ${E_SITEFILE} || die
		elisp-site-file-install ${E_SITEFILE} || die
	fi

	cd "${S}"
	dodoc BUGS ChangeLog NEWS PGPKEYS PORTING README* TODO
	newdoc term/PostScript/README README-ps
	newdoc term/js/README README-js
	use lua && newdoc term/lua/README README-lua

	if use doc; then
		# Demo files
		insinto /usr/share/${PN}/${GP_VERSION}
		doins -r demo || die
		rm -f "${ED}"/usr/share/${PN}/${GP_VERSION}/demo/Makefile*
		rm -f "${ED}"/usr/share/${PN}/${GP_VERSION}/demo/binary*
		# Manual
		dodoc docs/gnuplot.pdf
		# Tutorial
		dodoc tutorial/{tutorial.dvi,tutorial.pdf}
		# FAQ
		dodoc FAQ.pdf
		# Documentation for making PostScript files
		docinto psdoc
		dodoc docs/psdoc/{*.doc,*.tex,*.ps,*.gpi,README}
	fi

	if use emacs || use xemacs; then
		docinto emacs
		dodoc lisp/ChangeLog lisp/README
		use doc && dodoc lisp/gpelcard.pdf
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use latex && texmf-update

	if use svga; then
		einfo "In order to enable ordinary users to use SVGA console graphics"
		einfo "gnuplot needs to be set up as setuid root.  Please note that"
		einfo "this is usually considered to be a security hazard."
		einfo "As root, manually \"chmod u+s /usr/bin/gnuplot\"."
	fi
	if use gd; then
		echo
		einfo "For font support in png/jpeg/gif output, you may have to"
		einfo "set the GDFONTPATH and GNUPLOT_DEFAULT_GDFONT environment"
		einfo "variables. See the FAQ file in /usr/share/doc/${PF}/"
		einfo "for more information."
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
	use latex && texmf-update
}
