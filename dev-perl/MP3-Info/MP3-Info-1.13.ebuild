# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MP3-Info/MP3-Info-1.13.ebuild,v 1.7 2006/01/31 21:26:03 agriffis Exp $

inherit perl-module

DESCRIPTION="A Perl module to manipulate/fetch info from MP3 files"
SRC_URI="mirror://cpan/authors/id/C/CN/CNANDOR/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~cnandor/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha ~amd64 hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"

