# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Algorithm-Diff/Algorithm-Diff-1.1901.ebuild,v 1.2 2005/05/21 08:43:26 blubb Exp $

inherit perl-module

CATEGORY="dev-perl"

DESCRIPTION="Algorithm::Diff - Compute intelligent differences between two files / lists"
HOMEPAGE="http://search.cpan.org/~tyemq/${P}/"
SRC_URI="mirror://cpan/authors/id/T/TY/TYEMQ/Algorithm-Diff-1.1901.zip"
LICENSE="|| ( Artistic GPL-2 )"
IUSE=""
SLOT="0"
KEYWORDS="~x86 ~ppc ~sparc ~alpha ~ppc64 ~amd64"

DEPEND="${DEPEND} app-arch/unzip"

SRC_TEST="do"
