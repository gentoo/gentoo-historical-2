# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/giflib/giflib-4.1.6.ebuild,v 1.8 2007/12/25 17:40:28 armin76 Exp $

inherit eutils libtool

DESCRIPTION="Library to handle, display and manipulate GIF images"
HOMEPAGE="http://sourceforge.net/projects/giflib/"
SRC_URI="mirror://sourceforge/giflib/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE="rle X"

DEPEND="!media-libs/libungif
	X? (
		x11-libs/libXt
		x11-libs/libX11
		x11-libs/libICE
		x11-libs/libSM
	)
	rle? ( media-libs/urt )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gif2rle.patch
	elibtoolize
	epunt_cxx
}

src_compile() {
	econf \
		$(use_enable X x11) \
		$(
			# prevent circular depend #111455
			has_version media-libs/urt \
				|| --disable-rle \
				&& use_enable rle \
		) \
		--disable-gl \
		|| die
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS BUGS ChangeLog NEWS ONEWS README TODO doc/*.txt
	dohtml -r doc
}
