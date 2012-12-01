# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/ltrace/ltrace-0.7.1-r1.ebuild,v 1.1 2012/12/01 13:01:33 radhermit Exp $

EAPI=5

inherit eutils autotools

NUM="3844"

DESCRIPTION="trace library calls made at runtime"
HOMEPAGE="http://ltrace.alioth.debian.org/"
SRC_URI="https://alioth.debian.org/frs/download.php/${NUM}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-alpha ~amd64 ~arm ~ia64 ~mips ~ppc ~ppc64 ~x86"
IUSE="debug test unwind"

RDEPEND="dev-libs/elfutils
	unwind? ( sys-libs/libunwind )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-util/dejagnu )"

src_prepare() {
	epatch "${FILESDIR}"/${P}-libunwind-pkgconfig.patch
	sed -i '/^dist_doc_DATA/d' Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-werror \
		$(use_enable debug) \
		$(use_with unwind libunwind)
}
