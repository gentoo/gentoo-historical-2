# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Compress-Zlib/Compress-Zlib-1.22.ebuild,v 1.10 2004/06/25 00:14:29 agriffis Exp $

inherit perl-module

DESCRIPTION="A Zlib perl module"
HOMEPAGE="http://cpan.pair.com/modules/by-module/Compress/${P}.readme"
SRC_URI="http://cpan.pair.com/modules/by-module/Compress/${P}.tar.gz"

LICENSE="Artistic | GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc alpha ~mips hppa ~amd64"

DEPEND=">=sys-libs/zlib-1.1.3"

mydoc="TODO"
