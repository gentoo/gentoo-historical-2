# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Geo-IP/Geo-IP-1.33.ebuild,v 1.2 2008/07/15 20:16:23 armin76 Exp $

MODULE_AUTHOR=BORISZ

inherit perl-module multilib

DESCRIPTION="Look up country by IP Address"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha ~amd64 ~hppa ia64 ~ppc sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-libs/geoip
	dev-lang/perl"

myconf="${myconf} LIBS=-L/usr/$(get_libdir)"
