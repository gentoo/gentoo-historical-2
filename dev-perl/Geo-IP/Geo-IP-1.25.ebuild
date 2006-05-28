# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Geo-IP/Geo-IP-1.25.ebuild,v 1.8 2006/05/28 10:47:11 kloeri Exp $

inherit perl-module multilib

IUSE=""
DESCRIPTION="Look up country by IP Address"
SRC_URI="mirror://cpan/authors/id/T/TJ/TJMATHER/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/T/TJ/TJMATHER/${P}.readme"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="alpha amd64 ppc sparc x86"
DEPEND="dev-libs/geoip"

myconf="${myconf} LIBS='-L/usr/$(get_libdir)'"
