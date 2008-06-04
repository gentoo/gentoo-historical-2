# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Font-TTF/Font-TTF-0.43.ebuild,v 1.3 2008/06/04 14:21:43 aballier Exp $

inherit perl-module

DESCRIPTION="This module is used for compiling and altering fonts."
HOMEPAGE="http://search.cpan.org/~mhosken/Font-TTF-0.43/"
SRC_URI="mirror://cpan/authors/id/M/MH/MHOSKEN/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc64 ~x86 ~x86-fbsd"
IUSE=""
SRC_TEST="do"

DEPEND="dev-perl/Compress-Zlib
	dev-perl/XML-Parser
	dev-lang/perl"
