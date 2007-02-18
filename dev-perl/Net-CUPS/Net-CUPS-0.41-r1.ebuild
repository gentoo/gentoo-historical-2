# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-CUPS/Net-CUPS-0.41-r1.ebuild,v 1.5 2007/02/18 12:53:02 armin76 Exp $

inherit perl-module

DESCRIPTION="CUPS C API Interface"
HOMEPAGE="http://search.cpan.org/~dhageman/"
SRC_URI="mirror://cpan/authors/id/D/DH/DHAGEMAN/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ia64 x86"
IUSE=""
SRC_TEST="do"

DEPEND=">=net-print/cups-1.1.21
		dev-perl/Exporter-Cluster
		dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd ${S}
	# - Make 0.41 work with CUPS 1.2* - see bug #143039 --ian
	epatch ${FILESDIR}/CUPS_FOO_DEVICE.patch
}
