# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Event-ExecFlow/Event-ExecFlow-0.63.ebuild,v 1.1 2007/04/16 11:31:08 mcummings Exp $

inherit perl-module

DESCRIPTION="High level API for event-based execution flow control"
SRC_URI="mirror://cpan/modules/by-module/Event/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~jred"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""
SRC_TEST="do"

DEPEND="dev-perl/AnyEvent
	dev-perl/libintl-perl
	dev-lang/perl"
