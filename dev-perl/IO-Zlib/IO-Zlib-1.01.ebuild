# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/IO-Zlib/IO-Zlib-1.01.ebuild,v 1.6 2004/06/25 00:40:38 agriffis Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="IO:: style interface to Compress::Zlib"
SRC_URI="http://www.cpan.org/modules/by-authors/id/T/TO/TOMHUGHES/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-authors/id/T/TO/TOMHUGHES/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 amd64 alpha ~hppa ~mips ppc sparc"

DEPEND="dev-perl/Compress-Zlib"

