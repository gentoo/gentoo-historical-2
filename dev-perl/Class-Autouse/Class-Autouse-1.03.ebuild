# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-Autouse/Class-Autouse-1.03.ebuild,v 1.2 2004/02/22 20:35:37 agriffis Exp $

inherit perl-module
DESCRIPTION="Defer loading of one or more classes"
SRC_URI="http://cpan.org/modules/by-module/Class/${P}.tar.gz"
HOMEPAGE="http://cpan.org/modules/by-module/Class/${P}.readme"
IUSE=""
SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="~x86 amd64 ~alpha ~hppa ~mips ~ppc ~sparc"
newdepend "dev-perl/Test-Simple"
SRC_TEST="do"
