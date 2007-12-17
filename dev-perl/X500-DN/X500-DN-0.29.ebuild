# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/X500-DN/X500-DN-0.29.ebuild,v 1.4 2007/12/17 18:41:54 drac Exp $

inherit perl-module
DESCRIPTION="handle X.500 DNs (Distinguished Names), parse and format them"
SRC_URI="mirror://cpan/authors/id/R/RJ/RJOOP/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~rjoop/"

SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 arm ia64 ~ppc s390 sh sparc x86"
IUSE=""

SRC_TEST="do"

export OPTIMIZE="${CFLAGS}"

DEPEND="dev-perl/Parse-RecDescent
	dev-lang/perl"
