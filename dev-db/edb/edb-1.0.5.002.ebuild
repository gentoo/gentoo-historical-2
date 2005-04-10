# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/edb/edb-1.0.5.002.ebuild,v 1.1 2005/04/10 03:17:25 vapier Exp $

EKEY_STATE=snap
EHACKAUTOGEN=yes
inherit enlightenment flag-o-matic

DESCRIPTION="Enlightenment Data Base"
HOMEPAGE="http://www.enlightenment.org/pages/edb.html"

IUSE="gtk ncurses"

DEPEND="gtk? ( =x11-libs/gtk+-1* )
	ncurses? ( sys-libs/ncurses )"
RDEPEND="virtual/libc"

src_compile() {
	export MY_ECONF="
		--enable-compat185
		--enable-dump185
		$(use_enable gtk)
		$(use_enable ncurses)
	"
	use ppc && filter-lfs-flags
	enlightenment_src_compile
}
