# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/digest-md2/digest-md2-2.01.ebuild,v 1.2 2003/06/24 00:34:16 mcummings Exp $

inherit perl-module

MY_P=Digest-MD2-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl interface to the MD2 Algorithm"
SRC_URI="http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/${MY_P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ~alpha ~ppc ~sparc"
