# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Heap/Heap-0.50.ebuild,v 1.9 2004/07/14 17:47:45 agriffis Exp $

IUSE=""

inherit perl-module

CATEGORY="dev-perl"
DESCRIPTION="Heap - Perl extensions for keeping data partially sorted."
SRC_URI="http://www.cpan.org/modules/by-module/Heap/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Heap/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 ~ppc ~sparc alpha"

DEPEND="${DEPEND}"
