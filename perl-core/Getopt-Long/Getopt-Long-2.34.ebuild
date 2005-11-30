# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/Getopt-Long/Getopt-Long-2.34.ebuild,v 1.1.1.1 2005/11/30 10:11:13 chriswhite Exp $

inherit perl-module

DESCRIPTION="Advanced handling of command line options"
SRC_URI="mirror://cpan/authors/id/J/JV/JV/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/J/JV/JV/${P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 alpha ppc sparc hppa mips ia64 ppc64"
IUSE=""

DEPEND="dev-perl/PodParser"
