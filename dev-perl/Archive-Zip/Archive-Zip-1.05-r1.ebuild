# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Archive-Zip/Archive-Zip-1.05-r1.ebuild,v 1.3 2003/02/13 10:56:09 vapier Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="A wrapper that lets you read Zip archive members as if they were files"
SRC_URI="http://www.cpan.org/modules/by-module/Archive/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Archive/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 ppc sparc "

DEPEND="dev-perl/Compress-Zlib"
