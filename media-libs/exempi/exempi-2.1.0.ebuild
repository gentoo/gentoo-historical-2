# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/exempi/exempi-2.1.0.ebuild,v 1.1 2009/05/17 22:14:18 eva Exp $

EAPI="2"

inherit autotools eutils

DESCRIPTION="Exempi is a port of the Adobe XMP SDK to work on UNIX"
HOMEPAGE="http://libopenraw.freedesktop.org/wiki/Exempi"
SRC_URI="http://libopenraw.freedesktop.org/download/${P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE="examples test"

# Could only run tests with boot 1.37
RDEPEND="dev-libs/expat
	virtual/libiconv
	sys-libs/zlib"
DEPEND="${RDEPEND}
	test? ( >=dev-libs/boost-1.37.0 )"

src_prepare() {
	# Fix build with gcc 4.4, bug #267466
	epatch "${FILESDIR}/${P}-gcc44.patch"

	# don't waste time on autoreconf for those who don't want to run unit tests
	if use test; then
		epatch "${FILESDIR}/${PN}-1.99.9-boost.m4.BOOST_FIND_LIB.patch"
		eautoreconf
	fi
}

src_configure() {
	econf $(use_enable test unittest)
}

src_install() {
	emake DESTDIR="${D}" install || die "install failed"
	dodoc AUTHORS ChangeLog NEWS README || die "dodoc failed"

	if use examples ; then
		cd samples/source
		emake distclean
		cd "${S}"
		rm samples/Makefile* samples/source/Makefile* \
			samples/testfiles/Makefile*
		insinto "/usr/share/doc/${PF}"
		doins -r samples || die "doins failed"
	fi
}
