# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Getopt-Long/Getopt-Long-2.34.ebuild,v 1.9 2004/12/24 15:11:26 nigoro Exp $

inherit perl-module

DESCRIPTION="Advanced handling of command line options"
SRC_URI="http://www.cpan.org/modules/by-authors/id/J/JV/JV/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/J/JV/JV/${P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 alpha ppc sparc hppa ~mips ia64 ~ppc64"
IUSE=""

DEPEND="dev-perl/PodParser"
