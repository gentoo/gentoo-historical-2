# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/X11-Protocol/X11-Protocol-0.51-r2.ebuild,v 1.3 2004/06/25 01:09:43 agriffis Exp $

inherit perl-module eutils

S=${WORKDIR}/${P}
DESCRIPTION="Client-side interface to the X11 Protocol"
SRC_URI="http://www.cpan.org/modules/by-module/X11/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/X11/${P}.readme"

SLOT="0"
LICENSE="Artistic X11"
KEYWORDS="~x86 ~alpha ~sparc ppc"

DEPEND="${DEPEND}
		virtual/x11"

src_unpack() {
	unpack ${A}
	cd ${S}; epatch ${FILESDIR}/X11-Protocol-0.51_2.patch
}
