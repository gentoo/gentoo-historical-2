# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/crypt-random/crypt-random-1.13.ebuild,v 1.4 2004/02/26 06:13:02 kumba Exp $

inherit perl-module

MY_P=Crypt-Random-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Cryptographically Secure, True Random Number Generator"
HOMEPAGE="http://search.cpan.org/CPAN/authors/id/V/VI/VIPUL/${MY_P}.readme"
SRC_URI="http://search.cpan.org/CPAN/authors/id/V/VI/VIPUL/${MY_P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc ~alpha hppa ~amd64 ~mips"

DEPEND="dev-perl/math-pari
	dev-perl/class-loader"
