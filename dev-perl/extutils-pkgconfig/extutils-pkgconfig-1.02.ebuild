# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/extutils-pkgconfig/extutils-pkgconfig-1.02.ebuild,v 1.9 2005/01/15 14:04:50 corsair Exp $

inherit perl-module

MY_P=ExtUtils-PkgConfig-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="Converts Perl XS code into C code"
HOMEPAGE="http://search.cpan.org/~mlehmann/${MY_P}"
SRC_URI="http://search.cpan.org/CPAN/authors/id/M/ML/MLEHMANN/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="x86 ppc ~sparc ~mips ~alpha hppa ~amd64"
IUSE=""
