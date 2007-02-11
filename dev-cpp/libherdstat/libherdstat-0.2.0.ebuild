# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libherdstat/libherdstat-0.2.0.ebuild,v 1.3 2007/02/11 13:13:33 vapier Exp $

inherit eutils autotools

TEST_DATA_PV="20060119"
TEST_DATA_P="${PN/lib/}-test-data-${TEST_DATA_PV}"

DESCRIPTION="C++ library offering interfaces for portage-related things such as Gentoo-specific XML files, package searching, and version sorting"
HOMEPAGE="http://developer.berlios.de/projects/libherdstat/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2
	test? ( http://download.berlios.de/${PN}/${TEST_DATA_P}.tar.bz2 )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~s390 ~sh ~sparc ~x86"
IUSE="debug doc curl static test"

RDEPEND=">=dev-libs/xmlwrapp-0.5.0
	>=dev-cpp/libebt-1.1.0
	curl? ( net-misc/curl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"
RDEPEND="${RDEPEND}
	net-misc/wget"

pkg_setup() {
	if has test $FEATURES && ! use test ; then
		die "FEATURES=test is set but USE=test is not; tests will fail without USE=test"
	fi
}

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}"/${P}-gcc.patch
	AT_M4DIR="${WORKDIR}"/${P}/m4 eautoreconf
}

src_compile() {
	econf \
		--disable-examples \
		--with-test-data=${WORKDIR}/${TEST_DATA_P} \
		$(use_enable debug) \
		$(use_enable static) \
		$(use_with curl) \
		|| die "econf failed"

	emake || die "emake failed"

	use doc && { emake doxygen || die "failed to build API docs" ; }
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO NEWS

	if use doc ; then
		dohtml -r doc/html/*
		doman doc/man/*/*.[0-9]

		# examples
		cp -R examples ${D}/usr/share/doc/${PF}
		# remove all Makefile's and .{dep,lib}s directories
		find ${D}/usr/share/doc/${PF}/examples \
			\( -name 'Makefile*' -or -name '.*s' \) \
			-exec rm -fr {} \; 2>/dev/null
	fi
}
