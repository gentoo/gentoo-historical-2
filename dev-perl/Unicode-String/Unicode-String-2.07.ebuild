# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-String/Unicode-String-2.07.ebuild,v 1.5 2004/06/25 01:08:21 agriffis Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="String manipulation for Unicode strings"
SRC_URI="http://cpan.valueclick.com/modules/by-module/Unicode/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/Unicode/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="x86 amd64 ~ppc sparc alpha"

DEPEND="${DEPEND}
	>=dev-perl/MIME-Base64-2.11"
