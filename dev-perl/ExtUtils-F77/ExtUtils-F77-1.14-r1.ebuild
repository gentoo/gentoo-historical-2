# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ExtUtils-F77/ExtUtils-F77-1.14-r1.ebuild,v 1.7 2004/03/07 15:58:52 geoman Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Facilitate use of FORTRAN from Perl/XS code"
SRC_URI="http://cpan.valueclick.com/modules/by-module/ExtUtils/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/ExtUtils/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 ppc alpha hppa sparc ~mips"
