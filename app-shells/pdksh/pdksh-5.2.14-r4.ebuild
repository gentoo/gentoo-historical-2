# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/pdksh/pdksh-5.2.14-r4.ebuild,v 1.10 2002/12/09 04:17:43 manson Exp $

S=${WORKDIR}/${P}
DESCRIPTION="The Public Domain Korn Shell"
SRC_URI="ftp://ftp.cs.mun.ca/pub/pdksh/${P}.tar.gz
	 ftp://ftp.cs.mun.ca/pub/pdksh/${P}-patches.1"
HOMEPAGE="http://ww.cs.mun.ca/~michael/pdksh/"
KEYWORDS="x86 ppc sparc "
SLOT="0"
LICENSE="as-is"

DEPEND=">=sys-libs/glibc-2.1.3"

src_unpack() {
	unpack ${P}.tar.gz
	cd ${S}
	patch -p2 < ${DISTDIR}/${P}-patches.1
}
 
src_compile() {

	echo 'ksh_cv_dev_fd=${ksh_cv_dev_fd=yes}' > config.cache

	./configure \
		--prefix=/usr \
		|| die

	emake || die
}

src_install() {

	into /
	dobin ksh
	into usr
	doman ksh.1
	dodoc BUG-REPORTS ChangeLog* CONTRIBUTORS LEGAL NEWS NOTES PROJECTS README
	docinto etc
	dodoc etc/*

}
