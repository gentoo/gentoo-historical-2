# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/lyx/lyx-1.3.4.ebuild,v 1.17 2006/06/24 01:17:29 cardoe Exp $

inherit kde-functions eutils libtool

DESCRIPTION="WYSIWYM frontend for LaTeX"
HOMEPAGE="http://www.lyx.org/"
SRC_URI="ftp://ftp.lyx.org/pub/lyx/stable/${P}.tar.bz2
	http://movementarian.org/latex-xft-fonts-0.1.tar.gz
	http://www.math.tau.ac.il/~dekelts/lyx/files/hebrew.bind
	http://www.math.tau.ac.il/~dekelts/lyx/files/preferences"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc amd64"
IUSE="nls cups qt3 debug gnome"

# these dependencies need looking at.
# does lyx only need qt to compile but not run ?
# I'll look into it <obz@gentoo.org>
DEPEND="|| (
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
	qt3? ( =x11-libs/qt-3* ) !qt3? ( =x11-libs/xforms-1* )"

RDEPEND="${DEPEND}
	|| (
		virtual/x11
		(
			x11-libs/libXi
			x11-libs/libXrandr
			x11-libs/libXcursor
			x11-libs/libXft
		)
	)
	virtual/ghostscript
	virtual/aspell-dict
	dev-tex/latex2html
	media-gfx/imagemagick
	cups? ( virtual/lpr )
	app-text/rcs
	dev-util/cvs
	app-text/sgmltools-lite
	app-text/noweb
	dev-tex/chktex"

DEPEND="$DEPEND >=sys-devel/autoconf-2.58"

src_unpack() {
	unpack ${P}.tar.bz2
	unpack latex-xft-fonts-0.1.tar.gz
	cd ${S}
	epatch ${FILESDIR}/${PN}-1.3.2-nomktex.patch
	epatch ${FILESDIR}/${PN}-1.3.3-configure-diff
	epatch ${FILESDIR}/${P}-gcc34.patch
	elibtoolize || die
}

src_compile() {
	local myconf=""
	if use qt3 ; then
		set-qtdir 3
		myconf="$myconf --with-frontend=qt --with-qt-dir=${QTDIR}"
	else
		myconf="$myconf --with-frontend=xforms"
	fi

	export WANT_AUTOCONF=2.5

	local flags="${CFLAGS}"
	unset CFLAGS
	unset CXXFLAGS
	econf \
		`use_enable nls` \
		`use_enable debug` \
		${myconf} \
		--enable-optimization="$flags" \
		|| die
	# bug 57479
	emake -j1 || die "emake failed"

}

src_install() {
	einstall || die
	dodoc README* UPGRADING INSTALL* ChangeLog NEWS COPYING \
		ANNOUNCE ABOUT-NLS ${DISTDIR}/preferences
	insinto /usr/share/lyx/bind
	doins ${DISTDIR}/hebrew.bind

	# gnome menu entry
	if use gnome; then
		insinto /usr/share/applications
		doins ${FILESDIR}/lyx.desktop
	fi

	# install the latex-xft fonts, which should fix
	# the problems outlined in bug #15629
	# <obz@gentoo.org>
	cd ${WORKDIR}/latex-xft-fonts-0.1
	make DESTDIR=${D} install || die "Font installation failed"

}

pkg_postinst() {

	einfo "Updating the font cache"
	fc-cache -f --system-only

	draw_line
	einfo ""
	einfo "How to use Hebrew in LyX:"
	einfo "1. emerge app-text/ivritex."
	einfo "2. unzip /usr/share/doc/${P}/preferences.gz into ~/.lyx/preferences"
	einfo "or, read http://www.math.tau.ac.il/~dekelts/lyx/instructions2.html"
	einfo "for instructions on using lyx's own preferences dialog to equal effect."
	einfo "3. use lyx's qt interface (compile with USE=qt3) for maximum effect."
	einfo ""

	if ! useq qt3; then
	draw_line
	einfo ""
	einfo "If you have a multi-head setup not using xinerama you can only use lyx"
	einfo "on the 2nd head if not using qt (maybe due to a xforms bug). See bug #40392."
	einfo ""
	fi
}
