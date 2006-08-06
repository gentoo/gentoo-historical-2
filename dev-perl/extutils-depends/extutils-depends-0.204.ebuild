# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/extutils-depends/extutils-depends-0.204.ebuild,v 1.4 2006/08/06 02:19:14 mcummings Exp $

inherit perl-module

MY_P=ExtUtils-Depends-${PV}
S=${WORKDIR}/${MY_P}

DESCRIPTION="Easily build XS extensions that depend on XS extensions."
HOMEPAGE="http://search.cpan.org/~tsch/${MY_P}"
SRC_URI="http://search.cpan.org/CPAN/authors/id/T/TS/TSCH/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~hppa ~amd64 ~s390 ppc64"
IUSE=""


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
