# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/exiv2/exiv2-0.11.ebuild,v 1.4 2006/11/27 16:01:17 flameeyes Exp $

inherit eutils

DESCRIPTION="Exiv2 is a C++ library and a command line utility to access image metadata"
HOMEPAGE="http://www.exiv2.org/"
SRC_URI="http://www.exiv2.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86 ~x86-fbsd"
IUSE="doc unicode"

DEPEND="sys-libs/zlib
	virtual/libiconv"
RDEPEND="sys-libs/zlib"

src_unpack() {
	unpack ${A}
	cd "${S}"

	if use unicode; then
		einfo "Converting docs to UTF-8"
		for i in doc/cmd.txt; do
			iconv -f LATIN1 -t UTF-8 "${i}" > "${i}~" && mv -f "${i}~" "${i}" || rm -f "${i}~"
		done
	fi
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
	dodoc README doc/{ChangeLog,cmd.txt}
	use doc && dohtml doc/html/*
}
