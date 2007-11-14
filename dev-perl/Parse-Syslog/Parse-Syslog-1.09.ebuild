# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Parse-Syslog/Parse-Syslog-1.09.ebuild,v 1.8 2007/11/14 03:21:45 astinus Exp $

inherit perl-module
DESCRIPTION="Parse::Syslog - Parse Unix syslog files"
HOMEPAGE="http://search.cpan.org/~dschwei/${P}"
SRC_URI="mirror://cpan/authors/id/D/DS/DSCHWEI/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 ppc64 sparc x86"
IUSE=""
SRC_TEST="do"

DEPEND="dev-lang/perl
		virtual/perl-Time-Local
		dev-perl/File-Tail"
