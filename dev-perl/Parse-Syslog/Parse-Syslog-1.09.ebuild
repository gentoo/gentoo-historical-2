# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Parse-Syslog/Parse-Syslog-1.09.ebuild,v 1.1 2007/06/26 17:49:00 ian Exp $

inherit perl-module
DESCRIPTION="Parse::Syslog - Parse Unix syslog files"
HOMEPAGE="http://search.cpan.org/~dschwei/${P}"
SRC_URI="mirror://cpan/authors/id/D/DS/DSCHWEI/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""
SRC_TEST="do"

DEPEND="dev-lang/perl
		virtual/perl-Time-Local
		dev-perl/File-Tail"
