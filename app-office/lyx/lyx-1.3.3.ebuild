# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/lyx/lyx-1.3.3.ebuild,v 1.2 2003/10/08 08:25:50 obz Exp $


DESCRIPTION="WYSIWYM frontend for LaTeX"
HOMEPAGE="http://www.lyx.org/"
SRC_URI="ftp://ftp.lyx.org/pub/lyx/stable/${P}.tar.bz2
	http://www.math.tau.ac.il/~dekelts/lyx/files/hebrew.bind
	http://www.math.tau.ac.il/~dekelts/lyx/files/preferences"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86 ~ppc ~alpha"
IUSE="nls cups qt debug gnome"

# these dependencies need looking at.
# does lyx only need qt to compile but not run ?
# I'll look into it <obz@gentoo.org>
DEPEND="virtual/x11
	virtual/tetex
	>=dev-lang/perl-5
	nls? ( sys-devel/gettext )
	app-text/aiksaurus
	qt? ( >=x11-libs/qt-3 ) !qt? ( =x11-libs/xforms-1* )"

RDEPEND="${DEPEND}
	app-text/ghostscript
	app-text/xpdf
	virtual/aspell-dict
	app-text/gv
	dev-tex/latex2html
	media-gfx/imagemagick
	cups? ( virtual/lpr )
	app-text/rcs
	dev-util/cvs
	app-text/sgmltools-lite
	app-text/noweb
	dev-tex/chktex"

src_unpack() {

	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-1.3.2-nomktex.patch
	epatch ${FILESDIR}/${P}-configure-diff

}

src_compile() {
	local myconf=""
	if [ `use qt` ]; then
		inherit kde-functions
		set-qtdir 3
		myconf="$myconf --with-frontend=qt --with-qt-dir=${QTDIR}"
	else
		myconf="$myconf --with-frontend=xforms"
	fi

	export WANT_AUTOCONF_2_5=1

	local flags="${CFLAGS}"
	unset CFLAGS
	unset CXXFLAGS
	econf \
		`use_enable nls` \
		`use_enable debug` \
		${myconf} \
		--enable-optimization="$flags" \
		|| die
	emake || die "emake failed"

}

src_install() {
	einstall
	dodoc README* UPGRADING INSTALL* ChangeLog NEWS COPYING ANNOUNCE ABOUT-NLS $DISTDIR/preferences
	insinto /usr/share/lyx/bind
	doins $DISTDIR/hebrew.bind

	# gnome menu entry
	if use gnome; then
		insinto /usr/share/applications
		doins ${FILESDIR}/lyx.desktop
	fi

}

pkg_postinst() {
	if [ `use qt` ] ; then
		einfo	"WARNING: the QT gui, together with xft2+fontconfig (which you"
	 	einfo	"almost certainly have), suffer from one infamous bug that causes"
		einfo	"the matheditor not to display any special characters (the ones from"
		einfo	"the Computer Modern font family). Generated documents (.dvi, .ps...)"
		einfo	"are ok, since tex has right fonts from the bluesky package."
		einfo	"A proper solution was being worked on. Meanwhile you can install the"
		einfo	"BaKoMa fonts package; however they are not licensed for redistribution"
		einfo	"(not even embedded inside generated documents) and cannot be used in"
		einfo	"commercial environments (without a special agreement from the author)."
		einfo	"If that suits you, you can get them on CTAN or at ftp.lyx.org as"
		einfo	"latex-ttf-fonts-0.1.tar.gz. I was working on an alternative, free"
		einfo	"fonts package derived from bluesky, but got stuck; wuold be glad"
		einfo	"to see someone continuing the effort (see the relevant threads on the"
		einfo	"lyx-devel mailing list or mail me if you want to know more)."
	fi
	einfo ""
	einfo "================"
	einfo ""
	einfo "How to use Hebrew in LyX:"
	einfo "1. emerge app-text/ivritex."
	einfo "2. unzip /usr/share/doc/${P}/preferences.gz into ~/.lyx/preferences"
	einfo "or, read http://www.math.tau.ac.il/~dekelts/lyx/instructions2.html"
	einfo "for instructions on using lyx's own preferences dialog to equal effect."
	einfo "3. use lyx's qt interface (compile with USE=qt) for maximum effect."
}
