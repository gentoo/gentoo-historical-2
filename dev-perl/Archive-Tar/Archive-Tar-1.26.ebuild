# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Archive-Tar/Archive-Tar-1.26.ebuild,v 1.4 2005/11/13 21:51:25 halcy0n Exp $

inherit perl-module

DESCRIPTION="A Perl module for creation and manipulation of tar files"
HOMEPAGE="http://search.cpan.org/~kane/Archive-Tar-1.26/"
SRC_URI="mirror://cpan/authors/id/K/KA/KANE/${P}.tar.gz"
SRC_TEST="do"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE=""

DEPEND="dev-perl/IO-Zlib
	dev-perl/IO-String
	>=perl-core/Test-Harness-2.26"
