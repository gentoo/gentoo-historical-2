# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-OpenSSL-RSA/Crypt-OpenSSL-RSA-0.21.ebuild,v 1.16 2006/08/05 01:47:55 mcummings Exp $

inherit perl-module

DESCRIPTION="Crypt::OpenSSL::RSA module for perl"
HOMEPAGE="http://search.cpan.org/~iroberts/${P}/"
SRC_URI="mirror://cpan/authors/id/I/IR/IROBERTS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 mips ppc sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND="virtual/libc
	dev-perl/Crypt-OpenSSL-Random
	dev-libs/openssl
	dev-lang/perl"
RDEPEND="${DEPEND}"

mydoc="rfc*.txt"
