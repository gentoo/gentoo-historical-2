# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-cpp/libherdstat/libherdstat-0.1.0_p2.ebuild,v 1.1 2005/10/23 16:52:08 ka0ttic Exp $

TEST_DATA_PV="20051023"
TEST_DATA_P="${PN/lib/}-test-data-${TEST_DATA_PV}"

DESCRIPTION="C++ library offering interfaces for portage-related things such as Gentoo-specific XML files, package searching, and version sorting"
HOMEPAGE="http://developer.berlios.de/projects/libherdstat/"
SRC_URI="http://download.berlios.de/${PN}/${P}.tar.bz2
	test? ( http://download.berlios.de/${PN}/${TEST_DATA_P}.tar.bz2 )"
RESTRICT="primaryuri"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"
IUSE="debug doc curl static test"

RDEPEND=">=dev-libs/xmlwrapp-0.5.0
	curl? ( net-misc/curl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	doc? ( app-doc/doxygen )"
RDEPEND="${RDEPEND}
	!curl? ( net-misc/wget )"

src_compile() {
	econf \
		--with-test-data=${WORKDIR}/${TEST_DATA_P} \
		$(use_enable test tests) \
		$(use_enable debug) \
		$(use_enable static) \
		$(use_with curl) \
		|| die "econf failed"

	emake || die "emake failed"

	if use doc ; then
		emake docs || die "failed to build API docs"
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc AUTHORS ChangeLog README TODO NEWS

	if use doc ; then
		dohtml -r doc/${PV}/html/*
		doman doc/${PV}/man/*/*.[0-9]
	fi
}
