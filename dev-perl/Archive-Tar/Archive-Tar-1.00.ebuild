# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Archive-Tar/Archive-Tar-1.00.ebuild,v 1.4 2004/06/25 00:06:22 agriffis Exp $

inherit perl-module

S=${WORKDIR}/${P}

DESCRIPTION="A Perl module for creation and manipulation of tar files"
SRC_URI="http://www.cpan.org/modules/by-module/Archive/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/Archive/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ppc sparc alpha"

DEPEND="dev-perl/File-Spec
		dev-perl/IO-Zlib
		dev-perl/Test-Simple"
