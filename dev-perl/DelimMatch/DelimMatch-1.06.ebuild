# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DelimMatch/DelimMatch-1.06.ebuild,v 1.17 2009/07/02 20:31:22 jer Exp $

inherit perl-module
MY_P=${P}a

DESCRIPTION="A Perl 5 module for locating delimited substrings with proper nesting"
SRC_URI="mirror://cpan/authors/id/N/NW/NWALSH/${MY_P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~nwalsh/"

SLOT="0"
LICENSE="as-is"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-lang/perl"
