# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PodParser/PodParser-1.22.ebuild,v 1.8 2004/06/25 00:55:58 agriffis Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Print Usage messages based on your own pod"
SRC_URI="http://www.cpan.org/modules/by-authors/id/M/MA/MAREKR/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/M/MA/MAREKR/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 alpha ppc sparc hppa ~mips ia64"

DEPEND="|| ( >=dev-lang/perl-5.8.2-r1 dev-perl/File-Spec )"
