# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-OpenSSL-Random/Crypt-OpenSSL-Random-0.03-r1.ebuild,v 1.15 2004/04/18 02:28:46 randy Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Crypt::OpenSSL::Random module for perl"
SRC_URI="http://cpan.valueclick.com/authors/id/I/IR/IROBERTS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/IROBERTS/Crypt-OpenSSL-Random-${PV}/"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 ppc sparc alpha"

DEPEND="${DEPEND}
	dev-libs/openssl"

export OPTIMIZE="${CFLAGS}"
mydoc="ToDo"
