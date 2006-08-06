# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/WWW-Bugzilla/WWW-Bugzilla-0.6.ebuild,v 1.2 2006/08/06 01:01:45 mcummings Exp $

inherit perl-module

DESCRIPTION="automate interaction with bugzilla"
SRC_URI="mirror://cpan/authors/id/B/BM/BMC/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~bmc/${P}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND="${RDEPEND}
	dev-lang/perl"

DEPEND="${RDEPEND}"


