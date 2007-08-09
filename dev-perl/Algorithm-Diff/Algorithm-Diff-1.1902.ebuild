# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Algorithm-Diff/Algorithm-Diff-1.1902.ebuild,v 1.5 2007/08/09 14:16:11 dertobi123 Exp $

inherit perl-module

DESCRIPTION="Algorithm::Diff - Compute intelligent differences between two files / lists"
HOMEPAGE="http://search.cpan.org/~tyemq/"
SRC_URI="mirror://cpan/authors/id/T/TY/TYEMQ/${P}.tar.gz"
LICENSE="|| ( Artistic GPL-2 )"
IUSE=""
SLOT="0"
KEYWORDS="alpha ~amd64 ia64 ppc ppc64 sparc x86"

DEPEND="app-arch/unzip
	dev-lang/perl"

SRC_TEST="do"
