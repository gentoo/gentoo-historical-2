# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/digest-md2/digest-md2-2.03.ebuild,v 1.4 2004/05/30 15:52:07 kloeri Exp $

inherit perl-module

MY_P=Digest-MD2-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Perl interface to the MD2 Algorithm"
HOMEPAGE="http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/${MY_P}.readme"
SRC_URI="http://search.cpan.org/CPAN/authors/id/G/GA/GAAS/${MY_P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc alpha hppa ~amd64 ~mips"
