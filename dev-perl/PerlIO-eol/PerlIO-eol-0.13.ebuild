# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/PerlIO-eol/PerlIO-eol-0.13.ebuild,v 1.2 2005/02/05 14:29:50 absinthe Exp $

inherit perl-module

DESCRIPTION="PerlIO::eol - PerlIO layer for normalizing line endings"
SRC_URI="http://www.cpan.org/modules/by-module/PerlIO/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/PerlIO/${P}.readme"

SLOT="0"
LICENSE="Artistic"
SRC_TEST="do"
KEYWORDS="~x86 ~amd64"
IUSE=""
DEPEND="${DEPEND}
	>=dev-lang/perl-5.7.3"
