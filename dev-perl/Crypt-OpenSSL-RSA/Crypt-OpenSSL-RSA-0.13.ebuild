# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-OpenSSL-RSA/Crypt-OpenSSL-RSA-0.13.ebuild,v 1.14 2004/06/25 00:18:12 agriffis Exp $


inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Crypt::OpenSSL::RSA module for perl"
SRC_URI="http://www.cpan.org/authors/id/I/IR/IROBERTS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/IROBERTS/Crypt-OpenSSL-RSA-${PV}/"
LICENSE="Artistic | GPL-2"
DEPEND="virtual/glibc
	>=dev-lang/perl-5
	dev-perl/Crypt-OpenSSL-Random
	dev-libs/openssl"
KEYWORDS="x86 amd64 alpha"
SLOT="0"

mydoc="rfc*.txt"
