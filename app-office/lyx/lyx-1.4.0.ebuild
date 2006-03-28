# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/lyx/lyx-1.4.0.ebuild,v 1.1 2006/03/28 23:09:40 ehmsen Exp $

inherit kde-functions eutils libtool flag-o-matic

DESCRIPTION="WYSIWYM frontend for LaTeX"
HOMEPAGE="http://www.lyx.org/"
SRC_URI="ftp://ftp.lyx.org/pub/lyx/stable/${P}.tar.bz2
	ftp://ftp.lyx.org/pub/lyx/contrib/latex-xft-fonts-0.1.tar.gz
	http://www.math.tau.ac.il/~dekelts/lyx/files/hebrew.bind
	http://www.math.tau.ac.il/~dekelts/lyx/files/preferences"

# CJK
# cjk? ( qt? ( ftp://cellular.phys.pusan.ac.kr/CJK-LyX/qt/CJK-LyX-qt-${PV}-1.patch )
#              !qt? ( ftp://cellular.phys.pusan.ac.kr/CJK-LyX/xforms/CJK-LyX-xforms-${PV}-1.patch ) )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="cjk cups debug gtk nls qt"

RDEPEND="|| (
		virtual/x11
		(
			x11-libs/libXi
			x11-libs/libXrandr
			x11-libs/libXcursor
			x11-libs/libXft
		)
	)
	virtual/ghostscript
	virtual/pdfviewer
	virtual/psviewer
	virtual/aspell-dict
	dev-tex/latex2html
	dev-tex/dvipost
	media-gfx/imagemagick
	cups? ( virtual/lpr )
	app-text/sgmltools-lite
	app-text/noweb
	dev-tex/chktex"

# these dependencies need looking at.
# does lyx only need qt to compile but not run ?
# I'll look into it <obz@gentoo.org>
DEPEND="${RDEPEND}
	|| (
		virtual/x11
		(
			x11-libs/libX11
			x11-libs/libXt
			x11-libs/libXpm
			x11-proto/xproto
		)
	)
	virtual/tetex
	>=dev-lang/perl-5
	nls? ( sys-devel/gettext )
	app-text/aiksaurus
	dev-lang/python
	>=sys-devel/autoconf-2.58
	qt? ( =x11-libs/qt-3* )
	!qt? ( =x11-libs/xforms-1* )
	gtk?  (
		>=dev-cpp/gtkmm-2.4
		>=dev-cpp/libglademm-2.4
	)"

src_unpack() {
	if use cjk ; then
		eerror
		eerror "There is currently no CJK support for lyx-1.4.*"
		eerror "If you like this to change you will either have to wait for lyx-1.5,"
		eerror "or help create new patches for lyx-1.4.*"
		eerror "A good starting point is http://cellular.phys.pusan.ac.kr/cjk.html"
		eerror
		eerror "Until then, you will have to disable the cjk use flag for lyx or"
		eerror "continue to use lyx-1.3.6"
		die "lyx-1.4.* does not currently support CJK."
	fi
	unpack ${P}.tar.bz2 || die "unpacking lyx failed"
	unpack latex-xft-fonts-0.1.tar.gz || die "unpacking xft-fonts failed"
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.patch
	elibtoolize || die "elibtoolize failed "
}

src_compile() {
	local myconf=""

	# Choose qt over gtk, since gtk is not feature complete
	if use qt ; then
		set-qtdir 3
		myconf="$myconf --with-frontend=qt --with-qt-dir=${QTDIR}"
	elif use gtk ; then
		ewarn
		ewarn "GTK support for lyx is currently not feature complete."
		ewarn "Don't report any bugs about missing or faulty features to gentoo,"
		ewarn "instead you have the option of turning GTK support off by removing"
		ewarn "the gtk use flag or enable the gt use flag"
		ewarn "(or help implement the missing features at lyx.org)"
		ewarn
		myconf="$myconf --with-frontend=gtk"
	else
		myconf="$myconf --with-frontend=xforms"
	fi

	export WANT_AUTOCONF=2.5

	local flags="${CXXFLAGS} $(test_flag -fno-stack-protector) $(test_flag -fno-stack-protector-all)"
	unset CFLAGS
	unset CXXFLAGS
	econf \
		$(use_enable nls) \
		$(use_enable debug) \
		${myconf} \
		--enable-optimization="${flags/-Os}" \
		|| die "econf failed"

	# bug 57479
	emake || die "emake failed"

}

src_install() {
	einstall || die "einstall failed"

	dodoc README* UPGRADING ChangeLog NEWS ANNOUNCE ABOUT-NLS ${DISTDIR}/preferences

	insinto /usr/share/lyx/bind
	doins ${DISTDIR}/hebrew.bind

	domenu ${FILESDIR}/lyx.desktop

	# install the latex-xft fonts, which should fix
	# the problems outlined in bug #15629
	# <obz@gentoo.org>
	cd ${WORKDIR}/latex-xft-fonts-0.1
	make DESTDIR=${D} install || die "Font installation failed"

	mkfontscale ${D}/usr/share/fonts/latex-xft-fonts
	mkfontdir -e /usr/share/fonts/encodings \
		-e /usr/share/fonts/encodings/large \
		-e /usr/X11R6/$(get_libdir)/X11/fonts/encodings \
		${D}/usr/share/fonts/latex-xft-fonts
	HOME=/root fc-cache -f ${D}/usr/share/fonts/latex-xft-fonts

	# fix for bug 91108
	dodir /usr/share/texmf/tex/latex
	cd ${D}/usr/share/texmf/tex/latex
	ln -s ../../../lyx/tex lyx
}

pkg_postinst() {

	# fix for bug 91108
	texhash

	einfo ""
	einfo "How to use Hebrew in LyX:"
	einfo "1. emerge app-text/ivritex."
	einfo "2. unzip /usr/share/doc/${P}/preferences.gz into ~/.lyx/preferences"
	einfo "or, read http://www.math.tau.ac.il/~dekelts/lyx/instructions2.html"
	einfo "for instructions on using lyx's own preferences dialog to equal effect."
	einfo "3. use lyx's qt interface (compile with USE=qt) for maximum effect."
	einfo ""

	if ! useq qt ; then
		einfo ""
		einfo "If you have a multi-head setup not using xinerama you can only use lyx"
		einfo "on the 2nd head if not using qt (maybe due to a xforms bug). See bug #40392."
		einfo ""
	fi
}
