# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Unicode-String/Unicode-String-2.07.ebuild,v 1.1 2003/06/16 14:49:49 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${P}
DESCRIPTION="String manipulation for Unicode strings"
SRC_URI="http://cpan.valueclick.com/modules/by-module/Unicode/${P}.tar.gz"
HOMEPAGE="http://cpan.valueclick.com/modules/by-module/Unicode/${P}.readme"

SLOT="0"
LICENSE="Artistic"
KEYWORDS="~x86 ~ppc ~sparc ~alpha"

DEPEND="${DEPEND}
	>=dev-perl/MIME-Base64-2.11"
