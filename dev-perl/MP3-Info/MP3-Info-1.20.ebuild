# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/MP3-Info/MP3-Info-1.20.ebuild,v 1.9 2007/01/19 14:43:34 mcummings Exp $

inherit perl-module

DESCRIPTION="A Perl module to manipulate/fetch info from MP3 files"
SRC_URI="mirror://cpan/authors/id/D/DA/DANIEL/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~daniel/"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ~ppc64 sparc ~x86"
IUSE=""

SRC_TEST="do"



DEPEND="dev-lang/perl"
