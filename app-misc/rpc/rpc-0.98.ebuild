# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/rpc/rpc-0.98.ebuild,v 1.4 2004/06/24 22:32:02 agriffis Exp $

inherit eutils

DESCRIPTION="A fullscreen console-based RPN calculator that uses the curses library"

SRC_URI="http://www.eecs.umich.edu/~pelzlpj/rpc/${P}.tar.gz"
HOMEPAGE="http://www.eecs.umich.edu/~pelzlpj/rpc/"

KEYWORDS="x86 ppc sparc"
LICENSE="GPL-2"
SLOT="0"

DEPEND=">=dev-libs/ccmath-2.2
	sys-libs/ncurses"

IUSE=""

src_install() {
	einstall || die
	dodoc ChangeLog README TODO doc/{DESIGN,manual} || die "dodoc failed"
}
