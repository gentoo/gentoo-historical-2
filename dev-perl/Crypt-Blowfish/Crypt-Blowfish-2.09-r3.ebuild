# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Crypt-Blowfish/Crypt-Blowfish-2.09-r3.ebuild,v 1.2 2002/12/09 04:21:06 manson Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Crypt::Blowfish module for perl"
SRC_URI="http://www.cpan.org/authors/id/D/DP/DPARIS/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/author/DPARIS/Crypt-Blowfish-${PV}/"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ppc sparc  alpha"

DEPEND="virtual/glibc >=sys-devel/perl-5"

export OPTIMIZE="${CFLAGS}"
