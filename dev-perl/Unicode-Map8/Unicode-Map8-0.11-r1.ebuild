# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-Map8/Unicode-Map8-0.11-r1.ebuild,v 1.1 2002/10/30 07:20:40 seemant Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A Unicode Perl Module"
SRC_URI="http://cpan.valueclick.com/modules/by-module/Unicode/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/Unicode/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc sparc64 alpha"

DEPEND="${DEPEND}
	>=dev-perl/Unicode-String-2.06"

mydoc="TODO"
