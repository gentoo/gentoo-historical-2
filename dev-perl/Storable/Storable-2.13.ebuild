# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Storable/Storable-2.13.ebuild,v 1.6 2005/04/24 09:26:33 vapier Exp $

inherit perl-module

DESCRIPTION="The Perl Storable Module"
HOMEPAGE="http://www.cpan.org/modules/by-module/Storable/${P}.readme"
SRC_URI="mirror://cpan/authors/id/A/AM/AMS/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE=""

SRC_TEST="do"
