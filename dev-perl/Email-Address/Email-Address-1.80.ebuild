# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-Address/Email-Address-1.80.ebuild,v 1.1 2006/07/02 10:16:34 ian Exp $

inherit perl-module

DESCRIPTION="Email::Address - RFC 2822 Address Parsing and Creation"
HOMEPAGE="http://search.cpan.org/~cwest/${P}"
SRC_URI="mirror://cpan/authors/id/C/CW/CWEST/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="~x86"
IUSE="test"
SRC_TEST="do"

DEPEND="test? ( perl-core/Test-Simple )"
