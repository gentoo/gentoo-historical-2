# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/WWW-Mechanize/WWW-Mechanize-1.34.ebuild,v 1.4 2008/11/01 17:43:12 nixnut Exp $

inherit perl-module

DESCRIPTION="Handy web browsing in a Perl object"
SRC_URI="mirror://cpan/authors/id/P/PE/PETDANCE/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~petdance/"
IUSE="test"
SLOT="0"
LICENSE="|| ( Artistic GPL-2 )"
KEYWORDS="amd64 ia64 ppc sparc x86"

# Bug in the tests - improper use of HTTP::Server
SRC_TEST="do"

# configure to run the local tests, but not the ones which access the Internet
myconf="--local --mech-dump --nolive"

DEPEND="dev-lang/perl
	dev-perl/IO-Socket-SSL
	>=dev-perl/libwww-perl-5.76
	>=dev-perl/URI-1.25
	>=dev-perl/HTML-Parser-3.34
	dev-perl/Test-LongString
	test? ( dev-perl/Test-Pod
	dev-perl/Test-Taint
	dev-perl/Test-Warn
	dev-perl/Test-Memory-Cycle )"
