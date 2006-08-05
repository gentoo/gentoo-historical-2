# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-HTMLDoc/HTML-HTMLDoc-0.08.ebuild,v 1.5 2006/08/05 04:22:11 mcummings Exp $

inherit perl-module

DESCRIPTION="Perl interface to the htmldoc program for producing PDF-Files from HTML-Content"
HOMEPAGE="http://search.cpan.org/~mkfrankl/${P}/"
SRC_URI="mirror://cpan/authors/id/M/MF/MFRANKL/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86 ~sparc ~ppc ~amd64"
IUSE=""

SRC_TEST="do"

DEPEND="app-text/htmldoc
	dev-lang/perl"
RDEPEND="${DEPEND}"


