# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/OpenCA-X509/OpenCA-X509-0.9.8-r2.ebuild,v 1.5 2003/06/21 21:36:36 drobbins Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="The perl OpenCA::X509 Module"
SRC_URI="http://www.cpan.org/authors/id/M/MA/MADWOLF/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/authors/id/M/MA/MADWOLF/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 ppc sparc alpha"
export OPTIMIZE="${CFLAGS}"

src_compile() {

	cd ${S}
	cp Makefile.PL Makefile.PL.bak
	sed -e "s|'OpenCA::OpenSSL'|{'OpenCA::OpenSSL'}|g" Makefile.PL.bak > Makefile.PL
	perl-module_src_compile

}
