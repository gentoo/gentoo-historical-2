# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-OpenSSL-RSA/Crypt-OpenSSL-RSA-0.25.ebuild,v 1.6 2007/08/09 14:30:17 dertobi123 Exp $

inherit perl-module

DESCRIPTION="Crypt::OpenSSL::RSA module for perl"
HOMEPAGE="http://search.cpan.org/~iroberts/${P}/"
SRC_URI="mirror://cpan/authors/id/I/IR/IROBERTS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ia64 ~m68k mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND="dev-perl/Crypt-OpenSSL-Bignum
	dev-perl/Crypt-OpenSSL-Random
	dev-libs/openssl
	dev-lang/perl"

SRC_TEST="do"

mydoc="rfc*.txt"
