# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Safe-Hole/Safe-Hole-0.10.ebuild,v 1.5 2006/07/10 22:04:04 agriffis Exp $

inherit perl-module

DESCRIPTION="Exec subs in the original package from Safe"
SRC_URI="mirror://cpan/authors/id/S/SE/SEYN/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/S/SE/SEYN/${P}.readme"
IUSE=""

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="ia64 sparc x86"

SRC_TEST="do"
