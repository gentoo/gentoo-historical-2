# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/ack/ack-1.86.ebuild,v 1.1 2008/08/04 20:01:07 rajiv Exp $

inherit perl-module

DESCRIPTION="ack is a tool like grep, aimed at programmers with large trees of
heterogeneous source code"
HOMEPAGE="http://www.petdance.com/ack/"
SRC_URI="mirror://cpan/authors/id/P/PE/PETDANCE/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=">=dev-perl/File-Next-1.02
	dev-lang/perl"
