# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Finance-Quote/Finance-Quote-1.07.ebuild,v 1.5 2003/06/08 04:32:05 rac Exp $

inherit perl-module

MY_P=${P/.3_/c-}
S=${WORKDIR}/${MY_P}
CATEGORY="dev-perl"
DESCRIPTION="The Perl Finance-Quote Module"
SRC_URI="http://www.cpan.org/modules/by-module/Finance/${MY_P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Finance/${MY_P}.readme"
USE=""
SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ppc sparc "

DEPEND="${DEPEND}
		dev-perl/libwww-perl
		dev-perl/HTML-TableExtract"

RDEPEND="${DEPEND}"

mydoc="TODO"
