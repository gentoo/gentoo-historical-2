# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/GSSAPI/GSSAPI-0.24.ebuild,v 1.13 2008/03/28 08:40:20 jer Exp $

inherit perl-module

DESCRIPTION="GSSAPI - Perl extension providing access to the GSSAPIv2 library"
HOMEPAGE="http://search.cpan.org/~agrolms/${P}/"
SRC_URI="mirror://cpan/authors/id/A/AG/AGROLMS/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="test"
SRC_TEST="do"

DEPEND="dev-lang/perl
		virtual/krb5
		test? ( perl-core/Test-Simple )"
