# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/edb/edb-1.0.5.20040417.ebuild,v 1.1 2004/04/19 03:56:39 vapier Exp $

EHACKAUTOGEN=yes
inherit enlightenment flag-o-matic

DESCRIPTION="Enlightment Data Base"
HOMEPAGE="http://www.enlightenment.org/pages/edb.html"

IUSE="${IUSE} ncurses gtk"

DEPEND="gtk? ( =x11-libs/gtk+-1* )
	ncurses? ( sys-libs/ncurses )"
RDEPEND="virtual/glibc"

src_compile() {
	export MY_ECONF="
		--enable-compat185
		--enable-dump185
	"
	use ppc && filter-flags -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE
	enlightenment_src_compile
}
