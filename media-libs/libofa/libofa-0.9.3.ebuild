# Copyright 2006-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libofa/libofa-0.9.3.ebuild,v 1.14 2008/02/06 19:44:19 coldwind Exp $

inherit eutils

DESCRIPTION="Open Fingerprint Architecture"
HOMEPAGE="http://code.google.com/p/musicip-libofa/"
SRC_URI="http://musicip-libofa.googlecode.com/files/${P}.tar.gz"

LICENSE="|| ( APL-1.0 GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="dev-libs/expat
	net-misc/curl
	>=sci-libs/fftw-3"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

pkg_setup() {
	[[ "${CXXFLAGS}" != "${CXXFLAGS/-ffast-math/}" ]] && \
		die "Correct your C[XX]FLAGS. Using -ffast-math is unsafe and not supported."
}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/libofa-0.9.3-gcc-4.patch
}

src_compile() {
	econf || die "configure failed"
	emake || die "emake failed"
}
src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS README
}
