# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-OpenSSL-RSA/Crypt-OpenSSL-RSA-0.19.ebuild,v 1.6 2004/05/07 18:21:48 gustavoz Exp $

inherit perl-module

DESCRIPTION="Crypt::OpenSSL::RSA module for perl"
HOMEPAGE="http://cpan.pair.com/author/IROBERTS/Crypt-OpenSSL-RSA-${PV}/"
SRC_URI="http://cpan.pair.com/authors/id/I/IR/IROBERTS/${P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc ~alpha hppa amd64 ~mips"

DEPEND="virtual/glibc
	dev-perl/Crypt-OpenSSL-Random
	dev-libs/openssl"

mydoc="rfc*.txt"
