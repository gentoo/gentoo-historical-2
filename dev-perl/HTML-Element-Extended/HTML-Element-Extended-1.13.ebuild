# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Element-Extended/HTML-Element-Extended-1.13.ebuild,v 1.10 2006/02/06 20:23:09 blubb Exp $

inherit perl-module

DESCRIPTION="Extension for manipulating a table composed of HTML::Element style components."
HOMEPAGE="http://search.cpan.org/search?module=${PN}"
SRC_URI="mirror://cpan/authors/id/M/MS/MSISK/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"

DEPEND=">=dev-perl/HTML-Tree-3.01"
