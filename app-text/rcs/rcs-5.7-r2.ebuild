# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/rcs/rcs-5.7-r2.ebuild,v 1.7 2002/12/09 04:17:44 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Revision Control System"
SRC_URI="ftp://ftp.gnu.org/gnu/rcs/${P}.tar.gz"
HOMEPAGE="http://www.gnu.org/software/rcs/"
SLOT="0"
LICENSE="GPL-2"

DEPEND="virtual/glibc"

RDEPEND="sys-apps/diffutils"

KEYWORDS="x86 ppc sparc "

src_compile() {

	./configure \
		--prefix=/usr \
		--host=${CHOST} \
		--with-diffutils || die

	cp ${FILESDIR}/conf.sh src/conf.sh

	emake || die

}

src_install () {

	make \
		prefix=${D}/usr \
		man1dir=${D}/usr/share/man/man1 \
		man3dir=${D}/usr/share/man/man3 \
		man5dir=${D}/usr/share/man/man5 \
		install || die

	dodoc ChangeLog COPYING CREDITS NEWS README REFS
}
