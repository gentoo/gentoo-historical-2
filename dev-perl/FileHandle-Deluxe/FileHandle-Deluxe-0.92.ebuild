# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/FileHandle-Deluxe/FileHandle-Deluxe-0.92.ebuild,v 1.8 2006/08/05 03:59:25 mcummings Exp $

inherit perl-module

DESCRIPTION="FileHandle with commit and rollback"
SRC_URI="mirror://cpan/authors/id/M/MI/MIKO/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="ia64 sparc x86"
IUSE=""


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
