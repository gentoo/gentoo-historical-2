# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Font-TTF/Font-TTF-0.43.ebuild,v 1.1 2008/06/01 19:33:42 loki_val Exp $

inherit perl-module

DESCRIPTION="This module is used for compiling and altering fonts."
HOMEPAGE="http://search.cpan.org/~mhosken/Font-TTF-0.43/"
SRC_URI="mirror://cpan/authors/id/M/MH/MHOSKEN/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""
SRC_TEST="do"

DEPEND="dev-perl/Compress-Zlib
	dev-perl/XML-Parser
	dev-lang/perl"
