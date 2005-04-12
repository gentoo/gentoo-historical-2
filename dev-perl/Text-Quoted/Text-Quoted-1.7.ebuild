# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Quoted/Text-Quoted-1.7.ebuild,v 1.5 2005/04/12 02:31:59 gustavoz Exp $

# this is an RT dependency

inherit perl-module

DESCRIPTION="Extract the structure of a quoted mail message"
SRC_URI="http://www.cpan.org/modules/by-authors/id/J/JE/JESSE/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/J/JE/JESSE/${P}.readme"

SRC_TEST="do"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="~x86 ~ppc ~sparc"

DEPEND="dev-perl/text-autoformat
	dev-perl/Text-Tabs+Wrap"
IUSE=""
