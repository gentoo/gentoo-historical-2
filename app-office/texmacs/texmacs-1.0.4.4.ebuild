# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/texmacs/texmacs-1.0.4.4.ebuild,v 1.2 2005/01/01 15:42:12 eradicator Exp $

# although flag-o-matic functions in portage, we should inherit it
inherit flag-o-matic

MY_P=${P/tex/TeX}-src
S=${WORKDIR}/${MY_P}

DESCRIPTION="GNU TeXmacs is a free GUI scientific editor, inspired by TeX and GNU Emacs."
SRC_URI="ftp://ftp.texmacs.org/pub/TeXmacs/targz/${MY_P}.tar.gz
	 ftp://ftp.texmacs.org/pub/TeXmacs/targz/TeXmacs-600dpi-fonts.tar.gz"
HOMEPAGE="http://www.texmacs.org/"
LICENSE="GPL-2"

SLOT="0"
IUSE="spell static"
# TeXmacs 1.0.X-r? -> stable release, TeXmacs 1.0.X.Y -> development release
KEYWORDS="~x86 ~ppc ~alpha ~sparc"

RDEPEND="virtual/tetex
	>=dev-util/guile-1.4
	>=sys-apps/sed-4
	virtual/x11
	spell? ( >=app-text/ispell-3.2 )"

DEPEND="${RDEPEND}
	virtual/ghostscript"

src_compile() {

	# we're not trusting texmacs optimisations here, so
	# we only want the following two
	strip-flags
	append-flags -fno-default-inline
	append-flags -fno-inline

	econf || die
	# and now replace the detected optimisations with our safer ones
	sed -i "s:\(^CXXOPTIMIZE = \).*:\1${CXXFLAGS}:" src/common.makefile
	# emake b0rked
	if use static ; then
		emake -j1 STATIC_TEXMACS || die
	else
		emake -j1 || die
	fi

}


src_install() {

	make DESTDIR=${D} install || die
	dodoc COMPILE COPYING LICENSE

	insinto /usr/share/applications
	doins ${FILESDIR}/TeXmacs.desktop

	# now install the fonts
	cd ${WORKDIR}
	dodir /usr/share/texmf
	cp -r fonts ${D}/usr/share/texmf/

}
