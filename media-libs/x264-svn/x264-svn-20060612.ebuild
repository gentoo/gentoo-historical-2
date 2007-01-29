# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/x264-svn/x264-svn-20060612.ebuild,v 1.9 2007/01/29 02:30:51 mr_bones_ Exp $

inherit multilib eutils toolchain-funcs

IUSE="debug mp4 threads"

DESCRIPTION="A free library for encoding X264/AVC streams."
HOMEPAGE="http://developers.videolan.org/x264.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ppc ppc64 ~sparc x86"

RDEPEND="mp4? ( >=media-video/gpac-0.4.1_pre20060122 )"

DEPEND="${RDEPEND}
	amd64? ( dev-lang/yasm )
	x86? ( dev-lang/nasm ) x86-fbsd? ( dev-lang/nasm )"

S=${WORKDIR}/${PN}

src_unpack() {
	unpack ${A}
	cd ${S}

	epatch "${FILESDIR}/${PN}-20060302-nostrip.patch"
}

src_compile() {
	./configure --prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--enable-pic --enable-shared \
		"--extra-cflags=${CFLAGS}" \
		"--extra-ldflags=${LDFLAGS}" \
		"--extra-asflags=${ASFLAGS}" \
		$(use_enable debug) \
		$(use_enable threads pthread) \
		$(use_enable mp4 mp4-output) \
		$myconf \
		|| die "configure failed"
	emake CC="$(tc-getCC)" || die "make failed"
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc AUTHORS
}
