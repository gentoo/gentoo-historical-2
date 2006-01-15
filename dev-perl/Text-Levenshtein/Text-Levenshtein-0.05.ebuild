# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Text-Levenshtein/Text-Levenshtein-0.05.ebuild,v 1.5 2006/01/15 17:48:35 mcummings Exp $

inherit perl-module

DESCRIPTION="An implementation of the Levenshtein edit distance"
HOMEPAGE="http://search.cpan.org/~jgoldberg/${P}/"
SRC_URI="mirror://cpan/authors/id/J/JG/JGOLDBERG/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc"
IUSE=""

SRC_TEST="do"
