# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-SSLeay/Net-SSLeay-1.23.ebuild,v 1.5 2004/02/29 20:04:33 weeve Exp $

inherit perl-module

MY_P=${PN/-/_}.pm-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Net::SSLeay module for perl"
SRC_URI="http://www.cpan.org/authors/id/SAMPO/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/authors/id/SAMPO/${MY_P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ~amd64 ~ppc sparc alpha ia64 ~mips"

DEPEND="${DEPEND} dev-libs/openssl"

export OPTIMIZE="$CFLAGS"

myconf="${myconf} /usr"
