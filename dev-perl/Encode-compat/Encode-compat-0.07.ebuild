# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Encode-compat/Encode-compat-0.07.ebuild,v 1.3 2005/05/17 15:24:25 gustavoz Exp $

inherit perl-module

DESCRIPTION="Encode.pm emulation layer"
HOMEPAGE="http://search.cpan.org/~autrijus/${P}/"
SRC_URI="mirror://cpan/authors/id/A/AU/AUTRIJUS/${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="x86 sparc"
IUSE=""

SRC_TEST="do"

DEPEND="dev-perl/Text-Iconv"
