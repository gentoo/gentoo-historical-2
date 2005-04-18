# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Convert-UUlib/Convert-UUlib-1.051.ebuild,v 1.2 2005/04/18 18:10:19 luckyduck Exp $

inherit perl-module

DESCRIPTION="A Perl interface to the uulib library"
SRC_URI="mirror://cpan/authors/id/M/ML/MLEHMANN/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Convert/MLEHMANN/${P}.readme"

SLOT="0"
LICENSE="Artistic GPL-2"
KEYWORDS="~x86 amd64 ~ppc ~sparc ~alpha ~ppc64"
IUSE=""

SRC_TEST="do"
