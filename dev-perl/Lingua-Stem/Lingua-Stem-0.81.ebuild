# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Lingua-Stem/Lingua-Stem-0.81.ebuild,v 1.3 2005/05/17 15:16:47 gustavoz Exp $

inherit perl-module

DESCRIPTION="Porter's stemming algorithm for 'generic' English"
HOMEPAGE="http://search.cpan.org/~snowhare/${P}/"
SRC_URI="mirror://cpan/authors/id/S/SN/SNOWHARE/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86 sparc"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/Snowball-Norwegian
		dev-perl/Snowball-Swedish
		dev-perl/Lingua-Stem-Snowball-Da
		dev-perl/Lingua-Stem-Fr
		dev-perl/Lingua-Stem-It
		dev-perl/Lingua-Stem-Ru
		dev-perl/Lingua-PT-Stemmer
		dev-perl/Text-German"
