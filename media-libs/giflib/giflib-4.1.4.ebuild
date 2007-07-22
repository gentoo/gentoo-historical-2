# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/giflib/giflib-4.1.4.ebuild,v 1.15 2007/07/22 09:40:53 dberkholz Exp $

inherit eutils libtool

DESCRIPTION="Library to handle, display and manipulate GIF images"
HOMEPAGE="http://sourceforge.net/projects/libungif/"
SRC_URI="mirror://sourceforge/libungif/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k mips ppc ppc64 s390 sh sparc x86 ~x86-fbsd"
IUSE="rle X"

DEPEND="X? ( x11-libs/libXt
		x11-libs/libX11
		x11-libs/libICE
		x11-libs/libSM
	)
	rle? ( media-libs/urt )
	!media-libs/libungif"

src_unpack() {
	unpack ${A}
	elibtoolize
	epunt_cxx
}

yesno() { use $1 && echo yes || echo no ; }
src_compile() {
	export \
		ac_cv_lib_gl_s_main=no \
		ac_cv_lib_rle_rle_hdr_init=$(yesno rle) \
		ac_cv_lib_X11_main=$(yesno X)
	# prevent circular depend #111455
	has_version media-libs/urt || export ac_cv_lib_rle_rle_hdr_init=no
	econf || die
	emake || die "emake failed"
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS BUGS ChangeLog NEWS ONEWS README TODO doc/*.txt
	dohtml -r doc
}
