# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-SSLeay/Net-SSLeay-1.23.ebuild,v 1.10 2004/06/25 00:50:53 agriffis Exp $

inherit perl-module

MY_P=${PN/-/_}.pm-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Net::SSLeay module for perl"
HOMEPAGE="http://www.cpan.org/authors/id/SAMPO/${MY_P}.readme"
SRC_URI="http://www.cpan.org/authors/id/SAMPO/${MY_P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 ppc sparc mips alpha arm hppa amd64 ia64 s390"

DEPEND="dev-libs/openssl"

export OPTIMIZE="$CFLAGS"

myconf="${myconf} /usr"
