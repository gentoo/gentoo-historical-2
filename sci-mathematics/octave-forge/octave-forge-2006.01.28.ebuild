# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-mathematics/octave-forge/octave-forge-2006.01.28.ebuild,v 1.6 2007/07/13 15:35:23 markusle Exp $

inherit eutils

DESCRIPTION="A collection of custom scripts, functions and extensions for GNU Octave"
HOMEPAGE="http://octave.sourceforge.net/"
SRC_URI="mirror://sourceforge/octave/${P}.tar.gz"

LICENSE="as-is"
KEYWORDS="~amd64 ~ppc ~sparc x86"
SLOT="0"
IUSE="ginac qhull X"

DEPEND="~sci-mathematics/octave-2.1.72
		sci-libs/netcdf
		media-libs/jpeg
		media-libs/libpng
		sci-libs/gsl
		dev-libs/libpcre
		sys-libs/readline
		sys-apps/texinfo
		sys-libs/ncurses
		virtual/lapack
		virtual/blas
		X? ( || ( x11-libs/libX11 virtual/x11 ) )
		!amd64? ( ginac? ( sci-mathematics/ginac ) )
		qhull? ( >=media-libs/qhull-3.1-r1 )"

src_compile() {
	econf $(use_with X) || die "econf failed"

	# patch Makefiles to avoid sandbox violations
	sed -e "s|\$(MPATH)|${D}/\$(MPATH)|" \
		-i ${S}/main/comm/Makefile \
		-i ${S}/main/comm/doc/Makefile \
		-i ${S}/main/fixed/Makefile \
		-i ${S}/main/fixed/doc/Makefile \
		|| die "failed to patch Makefiles"

	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "install failed"

	dodoc AUTHORS COPYING* ChangeLog RELEASE-NOTES TODO
}

pkg_postinst() {
	einfo "If you do not have GiNaC and Qhull installed, octave-forge did not"
	einfo "compile itself with support for the geometry and symbolic math"
	einfo "extensions. If you would like these features, please emerge ginac"
	einfo "and/or qhull and then re-emerge octave-forge. Alternately, you can"
	einfo "specify USE='ginac qhull' and re-emerge octave-forge; in that case"
	einfo "the ebuild will automatically install the additional packages."
}
