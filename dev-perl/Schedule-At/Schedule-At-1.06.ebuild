# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Schedule-At/Schedule-At-1.06.ebuild,v 1.5 2006/08/05 20:29:48 mcummings Exp $

inherit perl-module

DESCRIPTION="OS independent interface to the Unix 'at' command"
SRC_URI="mirror://cpan/authors/id/J/JO/JOSERODR/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/dist/Schedule-At/"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~ia64 sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="sys-process/at
	dev-lang/perl"
RDEPEND="${DEPEND}"

