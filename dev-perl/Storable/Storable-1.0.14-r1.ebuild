# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Storable/Storable-1.0.14-r1.ebuild,v 1.8 2004/07/14 20:29:44 agriffis Exp $

inherit perl-module

CATEGORY="dev-perl"
DESCRIPTION="The Perl Storable Module"
SRC_URI="http://www.cpan.org/modules/by-module/Storable/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Storable/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha"
IUSE=""

DEPEND="dev-perl/Test-Simple"
