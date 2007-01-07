# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Address/Email-Address-1.87.0.ebuild,v 1.6 2007/01/07 21:40:31 mcummings Exp $

inherit perl-module versionator

MY_PV="$(delete_version_separator 2)"
MY_P="${PN}-${MY_PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="Email::Address - RFC 2822 Address Parsing and Creation"
HOMEPAGE="http://search.cpan.org/~rjbs/${MY_P}"
SRC_URI="mirror://cpan/authors/id/R/RJ/RJBS/${MY_P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~ia64 ~ppc ~ppc64 sparc x86"
IUSE="test"
SRC_TEST="do"

DEPEND="test? ( virtual/perl-Test-Simple )
	dev-lang/perl"
