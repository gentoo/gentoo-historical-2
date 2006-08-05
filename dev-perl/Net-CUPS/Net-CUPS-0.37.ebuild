# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-CUPS/Net-CUPS-0.37.ebuild,v 1.6 2006/08/05 14:10:53 mcummings Exp $

inherit perl-module

DESCRIPTION="CUPS C API Interface"
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/D/DH/DHAGEMAN/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="ia64 x86"
IUSE=""
SRC_TEST="do"

DEPEND=">=net-print/cups-1.1.21
		dev-perl/Exporter-Cluster
		dev-lang/perl"
RDEPEND="${DEPEND}"
