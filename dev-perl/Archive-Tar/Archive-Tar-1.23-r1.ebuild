# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Archive-Tar/Archive-Tar-1.23-r1.ebuild,v 1.3 2005/03/12 10:59:00 corsair Exp $

inherit perl-module

DESCRIPTION="A Perl module for creation and manipulation of tar files"
HOMEPAGE="http://search.cpan.org/~kane/${P}/"
SRC_URI="mirror://cpan/authors/id/K/KA/KANE/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha ~amd64 ~ppc sparc x86 ppc64 mips"
IUSE=""

DEPEND="dev-perl/IO-Zlib
	dev-perl/IO-String
	>=dev-perl/Test-Harness-2.26"
