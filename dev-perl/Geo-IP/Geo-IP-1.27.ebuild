# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Geo-IP/Geo-IP-1.27.ebuild,v 1.12 2007/02/03 18:41:44 jokey Exp $

inherit perl-module multilib

DESCRIPTION="Look up country by IP Address"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/T/TJ/TJMATHER/${P}.readme"
SRC_URI="mirror://cpan/authors/id/T/TJ/TJMATHER/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-libs/geoip
	dev-lang/perl"
RDEPEND=${DEPEND}

myconf="${myconf} LIBS='-L/usr/$(get_libdir)'"
