# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Convert-BinHex/Convert-BinHex-1.119.ebuild,v 1.8 2006/08/05 01:35:34 mcummings Exp $

inherit perl-module

DESCRIPTION="Extract data from Macintosh BinHex files"
SRC_URI="mirror://cpan/authors/id/E/ER/ERYQ/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Convert/${P}.readme"

SLOT="0"
LICENSE="GPL-1"
KEYWORDS="amd64 ia64 ~ppc sparc x86"
IUSE=""
DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
