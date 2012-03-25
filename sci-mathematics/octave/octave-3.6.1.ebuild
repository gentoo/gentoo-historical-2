# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/octave/octave-3.6.1.ebuild,v 1.2 2012/03/25 15:55:06 armin76 Exp $

EAPI=4

AUTOTOOLS_AUTORECONF=yes
inherit autotools-utils toolchain-funcs

DESCRIPTION="High-level interactive language for numerical computations"
LICENSE="GPL-3"
HOMEPAGE="http://www.octave.org/"
SRC_URI="ftp://ftp.gnu.org/pub/gnu/${PN}/${P}.tar.bz2"

SLOT="0"
IUSE="curl doc fftw +glpk gnuplot +imagemagick opengl +qhull +qrupdate
	readline +sparse static-libs X zlib"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-libs/libpcre
	app-text/ghostscript-gpl
	sys-libs/ncurses
	virtual/lapack
	curl? ( net-misc/curl )
	fftw? ( sci-libs/fftw:3.0 )
	glpk? ( sci-mathematics/glpk )
	gnuplot? ( sci-visualization/gnuplot )
	imagemagick? ( || (
			media-gfx/graphicsmagick[cxx]
			media-gfx/imagemagick[cxx] ) )
	opengl? (
		media-libs/freetype:2
		media-libs/fontconfig
		>=x11-libs/fltk-1.3:1[opengl] )
	qhull? ( media-libs/qhull )
	qrupdate? ( sci-libs/qrupdate )
	readline? ( sys-libs/readline )
	sparse? (
		sci-libs/arpack
		sci-libs/camd
		sci-libs/ccolamd
		sci-libs/cholmod
		sci-libs/colamd
		sci-libs/cxsparse
		sci-libs/umfpack )
	X? ( x11-libs/libX11 )
	zlib? ( sys-libs/zlib )"

DEPEND="${RDEPEND}
	doc? (
		virtual/latex-base
		dev-texlive/texlive-genericrecommended
		sys-apps/texinfo )
	dev-util/gperf
	dev-util/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-3.4.3-{pkgbuilddir,help,texi}.patch )

src_configure() {
	# occasional fail on install, force regeneration  see bug #401189
	rm -f doc/interpreter/contributors.texi || die

	# hdf5 disabled because not really useful (bug #299876)
	local myconf="--without-magick"
	if use imagemagick; then
		if has_version media-gfx/graphicsmagick[cxx]; then
			myconf="--with-magick=GraphicsMagick"
		else
			myconf="--with-magick=ImageMagick"
		fi
	fi

	myeconfargs+=(
		--localstatedir="${EPREFIX}/var/state/octave"
		--without-hdf5
		--with-blas="$(pkg-config --libs blas)"
		--with-lapack="$(pkg-config --libs lapack)"
		$(use_enable doc docs)
		$(use_enable readline)
		$(use_with curl)
		$(use_with fftw fftw3)
		$(use_with fftw fftw3f)
		$(use_with glpk)
		$(use_with opengl)
		$(use_with qhull)
		$(use_with qrupdate)
		$(use_with sparse arpack)
		$(use_with sparse umfpack)
		$(use_with sparse colamd)
		$(use_with sparse ccolamd)
		$(use_with sparse cholmod)
		$(use_with sparse cxsparse)
		$(use_with X x)
		$(use_with zlib z)
		${myconf}
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc $(find doc -name \*.pdf)
	[[ -e test/fntests.log ]] && dodoc test/fntests.log
	echo "LDPATH=${EPREFIX}/usr/$(get_libdir)/${P}" > 99octave
	doenvd 99octave
}
