# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Convert-BER/Convert-BER-1.3101.ebuild,v 1.1 2003/06/07 11:39:18 mcummings Exp $

inherit perl-module

S=${WORKDIR}/${P}
CATEGORY="dev-perl"
DESCRIPTION="Class for encoding/decoding BER messages"
SRC_URI="http://cpan.pair.com/modules/by-module/Convert/${P}.tar.gz"
HOMEPAGE="http://cpan.pair.com/modules/by-module/Convert/${P}.readme"

SLOT="0"
LICENSE="Artistic | GPL-2"
KEYWORDS="x86 ~ppc ~sparc ~alpha"
