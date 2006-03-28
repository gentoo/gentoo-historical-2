# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-String/IO-String-1.08.ebuild,v 1.6 2006/03/28 23:06:33 agriffis Exp $

inherit perl-module

DESCRIPTION="IO::File interface for in-core strings"
HOMEPAGE="http://www.cpan.org/modules/by-module/IO/${P}.readme"
SRC_URI="mirror://cpan/authors/id/G/GA/GAAS/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ia64 ~m68k ~mips ~ppc ppc64 ~s390 ~sh sparc x86"
IUSE=""

SRC_TEST="do"
