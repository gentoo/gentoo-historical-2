# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Copy-Recursive/File-Copy-Recursive-0.30.ebuild,v 1.3 2007/01/23 00:40:29 kloeri Exp $

inherit perl-module

DESCRIPTION="uses File::Copy to recursively copy dirs"
HOMEPAGE="http://search.cpan.org/~dmuey/"
SRC_URI="mirror://cpan/authors/id/D/DM/DMUEY/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

DEPEND="dev-lang/perl"

SRC_TEST="do"
