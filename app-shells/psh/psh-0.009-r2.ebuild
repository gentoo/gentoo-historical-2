# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/psh/psh-0.009-r2.ebuild,v 1.6 2002/12/09 04:17:43 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Combines the interactive nature of a Unix shell with the power of Perl"
SRC_URI="http://www.focusresearch.com/gregor/psh/${P}.tar.gz"
HOMEPAGE="http://www.focusresearch.com/gregor/psh/"
LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc "

DEPEND=">=sys-devel/perl-5"

src_compile() {
	perl Makefile.PL

	make || die
}

src_install() {
	make PREFIX=${D}/usr prefix=${D}/usr INSTALLMAN3DIR=${D}/usr/share/man/man3 \
	INSTALLMAN1DIR=${D}/usr/share/man/man1 install || die

	dodoc COPYRIGHT HACKING MANIFEST README* RELEASE TODO
	dodoc examples/complete-examples
}








