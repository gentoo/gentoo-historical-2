# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Pager/IO-Pager-0.06.ebuild,v 1.7 2007/03/05 12:04:57 ticho Exp $

inherit perl-module

DESCRIPTION="Select a pager, optionally pipe it output if destination is a TTY"
SRC_URI="mirror://cpan/authors/id/J/JP/JPIERCE/${P}.tgz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/J/JP/JPIERCE/${P}.readme"

IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 ia64 ~ppc sparc x86"


DEPEND="dev-lang/perl"
