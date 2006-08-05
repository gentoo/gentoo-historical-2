# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-OpenSSL-Random/Crypt-OpenSSL-Random-0.03-r1.ebuild,v 1.21 2006/08/05 01:48:35 mcummings Exp $

inherit perl-module

DESCRIPTION="Crypt::OpenSSL::Random module for perl"
SRC_URI="mirror://cpan/authors/id/I/IR/IROBERTS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/IROBERTS/Crypt-OpenSSL-Random-${PV}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 ppc sparc alpha"
IUSE=""

DEPEND="dev-libs/openssl
	dev-lang/perl"
RDEPEND="${DEPEND}"

export OPTIMIZE="${CFLAGS}"
mydoc="ToDo"
