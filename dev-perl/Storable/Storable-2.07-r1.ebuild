# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Storable/Storable-2.07-r1.ebuild,v 1.7 2004/07/08 23:51:22 kloeri Exp $

inherit perl-module

DESCRIPTION="The Perl Storable Module"
SRC_URI="http://www.cpan.org/modules/by-module/Storable/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Storable/${P}.readme"
IUSE=""
SLOT="0"
LICENSE="Artistic"
KEYWORDS="ia64 x86 amd64 ~ppc alpha sparc hppa mips"

DEPEND="|| ( dev-perl/Test-Simple >=dev-lang/perl-5.8.0-r12 )"
