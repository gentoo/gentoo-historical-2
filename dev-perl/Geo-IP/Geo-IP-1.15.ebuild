# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Geo-IP/Geo-IP-1.15.ebuild,v 1.2 2003/06/30 00:44:08 solar Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="Look up country by IP Address"
SRC_URI="http://www.cpan.org/modules/by-authors/id/T/TJ/TJMATHER/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/T/TJ/TJMATHER/${P}.readme"
SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="~x86 ~sparc"
DEPEND="dev-libs/geoip"
