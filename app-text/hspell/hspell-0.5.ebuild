# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/hspell/hspell-0.5.ebuild,v 1.3 2004/06/24 22:39:08 agriffis Exp $

DESCRIPTION="A Hebrew spell checker"
HOMEPAGE="http://www.ivrix.org.il/projects/spell-checker/"
SRC_URI="http://ivrix.org.il/projects/spell-checker/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc alpha"
IUSE=""

DEPEND=">=dev-lang/perl-5.6.1"

src_compile() {
	mv Makefile Makefile.orig
	sed -e "s:/usr/local:/usr:" Makefile.orig > Makefile
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc README TODO WHANTSNEW
}
