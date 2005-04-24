# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Chart/Chart-2.3.ebuild,v 1.11 2005/04/24 15:41:11 mcummings Exp $

inherit perl-module

MY_P=${P/.3_/c-}
S=${WORKDIR}/${MY_P}
CATEGORY="dev-perl"
DESCRIPTION="The Perl Chart Module"
SRC_URI="mirror://cpan/authors/id/C/CH/CHARTGRP/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~chartgrp/${P}/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="x86 amd64 ppc sparc alpha ~ppc64"
IUSE=""

DEPEND="${DEPEND}
	>=dev-perl/GD-1.2"

SRC_TEST="do"

mydoc="TODO"
