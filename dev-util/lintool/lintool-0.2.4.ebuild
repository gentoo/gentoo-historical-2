# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/lintool/lintool-0.2.4.ebuild,v 1.5 2003/02/13 11:58:17 vapier Exp $

DESCRIPTION="Gentoo Linux \"lint\" utility"
HOMEPAGE="http://www.gentoo.org/~karltk/projects/lintool/"
SRC_URI="http://www.gentoo.org/~karltk/projects/lintool/releases/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~hppa ~alpha"
DEPEND=">=dev-lang/python-2.2"
S="${WORKDIR}/${P}"
IUSE=""

src_compile() {
	emake
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc README NEWS ChangeLog COPYING AUTHORS
}
