# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Log-Agent/Log-Agent-0.306.ebuild,v 1.8 2006/08/05 13:36:44 mcummings Exp $

inherit perl-module

DESCRIPTION="A general logging framework"
SRC_URI="mirror://cpan/authors/id/M/MR/MROGASKI/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/M/MR/MROGASKI/${P}.readme"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~amd64 ppc x86"
IUSE=""


DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
