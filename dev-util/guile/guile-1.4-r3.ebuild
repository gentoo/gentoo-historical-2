# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/guile/guile-1.4-r3.ebuild,v 1.9 2002/10/04 20:58:58 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Guile is an interpreter for Scheme"
SRC_URI="ftp://prep.ai.mit.edu/gnu/guile/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/guile/"

SLOT="1.4"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64"

DEPEND=">=sys-libs/ncurses-5.1
	>=sys-libs/readline-4.1"

src_unpack() {
	unpack ${A}
	cd ${S}
	cp  ${FILESDIR}/net_db.c libguile/
}

src_compile() {

	econf \
		--with-threads \
		--with-modules || die

	make || die
}

src_install() {
	einstall || die

	dodoc AUTHORS COPYING ChangeLog GUILE-VERSION HACKING NEWS 
	dodoc README SNAPSHOTS THANKS
}
