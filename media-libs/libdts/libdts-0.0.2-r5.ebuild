# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libdts/libdts-0.0.2-r5.ebuild,v 1.6 2006/08/12 12:38:01 corsair Exp $

inherit eutils toolchain-funcs autotools

DESCRIPTION="library for decoding DTS Coherent Acoustics streams used in DVD"
HOMEPAGE="http://www.videolan.org/dtsdec.html"
SRC_URI="http://www.videolan.org/pub/videolan/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ia64 ~mips ppc ppc64 sh sparc ~x86 ~x86-fbsd"
IUSE="oss debug"
RESTRICT="test"

src_unpack() {
	unpack ${A}
	cd "${S}"
	mkdir "${S}/m4"

	epatch "${FILESDIR}/${P}-strict-aliasing.patch"
	epatch "${FILESDIR}/${P}-libtool.patch"
	epatch "${FILESDIR}/${P}-freebsd.patch"
	[[ $(gcc-major-version)$(gcc-minor-version) -ge 41 ]] && \
		epatch "${FILESDIR}/${P}-visibility.patch"

	AT_M4DIR="m4" eautoreconf
}

src_compile() {
	econf $(use_enable oss) $(use_enable debug) || die
	emake OPT_CFLAGS="" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README TODO doc/libdts.txt
}
