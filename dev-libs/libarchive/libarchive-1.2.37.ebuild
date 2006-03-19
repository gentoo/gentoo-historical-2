# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libarchive/libarchive-1.2.37.ebuild,v 1.6 2006/03/19 21:02:15 flameeyes Exp $

inherit eutils libtool

DESCRIPTION="Library to create and read several different archive formats."
HOMEPAGE="http://people.freebsd.org/~kientzle/libarchive/"
SRC_URI="http://people.freebsd.org/~kientzle/libarchive/src/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc-macos ~x86"
IUSE=""

RDEPEND="app-arch/bzip2
	sys-libs/zlib
	!>=app-arch/bsdtar-1.2.51"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd ${S}

	elibtoolize
	epunt_cxx
}

src_install() {
	make DESTDIR="${D}" install

	if [[ ${CHOST} != *-darwin* ]]; then
		dodir /$(get_libdir)
		mv ${D}/usr/$(get_libdir)/*.so* ${D}/$(get_libdir)
		gen_usr_ldscript libarchive.so
	fi
}
