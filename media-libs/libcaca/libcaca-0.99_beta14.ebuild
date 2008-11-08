# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libcaca/libcaca-0.99_beta14.ebuild,v 1.4 2008/11/08 14:17:26 nixnut Exp $

inherit eutils autotools libtool mono

MY_P="${P/_beta/.beta}"

DESCRIPTION="A library that creates colored ASCII-art graphics"
HOMEPAGE="http://libcaca.zoy.org/"
SRC_URI="http://libcaca.zoy.org/files/${PN}/${MY_P}.tar.gz"

LICENSE="WTFPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="doc imlib mono ncurses nocxx opengl ruby slang X"

RDEPEND="ncurses? ( >=sys-libs/ncurses-5.3 )
	slang? ( >=sys-libs/slang-1.4 )
	imlib? ( media-libs/imlib2 )
	X? ( x11-libs/libX11 x11-libs/libXt )
	opengl? ( virtual/opengl media-libs/freeglut )
	mono? ( dev-lang/mono )
	ruby? ( virtual/ruby )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen
		virtual/latex-base
		|| ( dev-texlive/texlive-fontsrecommended app-text/tetex app-text/ptex ) )"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${PN}-0.99_beta14-deoptimise.patch"
	epatch "${FILESDIR}/${P}-nogl.patch"

	eautoreconf
	elibtoolize
}

src_compile() {
	# temp font fix #44128
	export VARTEXFONTS="${T}/fonts"

	econf \
		$(use_enable doc) \
		$(use_enable ncurses) \
		$(use_enable slang) \
		$(use_enable imlib imlib2) \
		$(use_enable X x11) $(use_with X x) --x-libraries=/usr/$(get_libdir) \
		$(use_enable opengl gl) \
		$(use_enable !nocxx cxx) \
		$(use_enable mono csharp) \
		$(use_enable ruby) \
		|| die "econf failed"
	emake || die "emake failed"
	unset VARTEXFONTS
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog NEWS NOTES README
}
