# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Perl-Critic/Perl-Critic-0.18.ebuild,v 1.4 2006/10/13 16:58:24 mcummings Exp $

inherit perl-module

DESCRIPTION="Critique Perl source code for best-practices"
HOMEPAGE="http://search.cpan.org/search?query=${PN}"
SRC_URI="mirror://cpan/authors/id/T/TH/THALJEF/perlcritic/${P}.tar.gz"


LICENSE="Artistic"
SLOT="0"
KEYWORDS="amd64 sparc ~x86"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/Module-Pluggable
	dev-perl/Config-Tiny
		dev-perl/List-MoreUtils
		dev-perl/IO-String
		dev-perl/String-Format
		dev-perl/perltidy
		dev-perl/PPI
	dev-lang/perl"
