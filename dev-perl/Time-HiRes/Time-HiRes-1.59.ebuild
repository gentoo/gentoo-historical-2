# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Time-HiRes/Time-HiRes-1.59.ebuild,v 1.7 2005/03/14 13:21:58 mcummings Exp $

inherit perl-module

DESCRIPTION="Perl Time::HiRes. High resolution alarm, sleep, gettimeofday, interval timers"
HOMEPAGE="http://search.cpan.org/author/JHI/${P}/"
SRC_URI="mirror://cpan/authors/id/J/JH/JHI/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="x86 sparc ~alpha ~amd64 ~ppc64"
IUSE=""

DEPEND=""
RDEPEND=""

mydoc="TODO"

SRC_TEST="do"
