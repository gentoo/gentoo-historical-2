# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/guile/guile-1.5.4.ebuild,v 1.8 2003/02/13 11:56:02 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Guile is an interpreter for Scheme"
SRC_URI="ftp://alpha.gnu.org/gnu/guile/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/guile/"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc "

DEPEND=">=sys-libs/ncurses-5.1
	>=sys-libs/readline-4.1"

src_compile() {

	econf \
		--with-threads \
		--with-modules || die

	emake || die
}

src_install() {

	einstall || die

	dodoc AUTHORS COPYING ChangeLog GUILE-VERSION HACKING NEWS 
	dodoc README SNAPSHOTS THANKS
}
