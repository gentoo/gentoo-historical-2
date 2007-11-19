# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Linux-Smaps/Linux-Smaps-0.05.ebuild,v 1.1 2007/11/19 18:47:51 ian Exp $

inherit perl-module

DESCRIPTION="Linux::Smaps - a Perl interface to /proc/PID/smaps"
HOMEPAGE="http://search.cpan.org/~opi/${P}/"
SRC_URI="mirror://cpan/authors/id/O/OP/OPI/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="dev-lang/perl
		dev-perl/Class-Member"
