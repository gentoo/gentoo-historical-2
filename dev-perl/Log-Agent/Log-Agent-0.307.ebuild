# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Log-Agent/Log-Agent-0.307.ebuild,v 1.18 2007/06/03 04:59:03 kumba Exp $

inherit perl-module

DESCRIPTION="A general logging framework"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/M/MR/MROGASKI/${P}.readme"
SRC_URI="mirror://cpan/authors/id/M/MR/MROGASKI/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="dev-lang/perl"
