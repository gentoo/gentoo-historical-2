# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/OpenCA-X509/OpenCA-X509-0.9.8-r1.ebuild,v 1.2 2002/10/04 05:22:24 vapier Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="The perl OpenCA::X509 Module"
SRC_URI="http://www.cpan.org/authors/id/M/MA/MADWOLF/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/authors/id/M/MA/MADWOLF/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ppc sparc sparc64"
export OPTIMIZE="${CFLAGS}"

src_compile() {

	cd ${S}
	cp Makefile.PL Makefile.PL.bak
	sed -e "s|'OpenCA::OpenSSL'|{'OpenCA::OpenSSL'}|g" Makefile.PL.bak > Makefile.PL
	perl-module_src_compile

}
