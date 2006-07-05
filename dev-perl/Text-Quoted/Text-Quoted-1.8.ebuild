# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Quoted/Text-Quoted-1.8.ebuild,v 1.4 2006/07/05 11:21:20 ian Exp $

# this is an RT dependency

inherit perl-module

DESCRIPTION="Extract the structure of a quoted mail message"
SRC_URI="mirror://cpan/authors/id/J/JE/JESSE/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/J/JE/JESSE/${P}.readme"

SRC_TEST="do"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~ia64 ~ppc sparc x86"

DEPEND="dev-perl/text-autoformat
	dev-perl/Text-Tabs+Wrap"
RDEPEND="${DEPEND}"
IUSE=""