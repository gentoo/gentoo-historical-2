# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/X11-Protocol/X11-Protocol-0.51-r1.ebuild,v 1.1 2003/10/11 09:42:46 taviso Exp $

inherit perl-module eutils

S=${WORKDIR}/${P}
DESCRIPTION="Client-side interface to the X11 Protocol"
SRC_URI="http://www.cpan.org/modules/by-module/X11/${P}.tar.gz"
HOMEPAGE="http://www.cpan.org/modules/by-module/X11/${P}.readme"

SLOT="0"
LICENSE="Artistic X11"
KEYWORDS="~x86 ~alpha ~sparc"

DEPEND="${DEPEND}
		virtual/x11"

src_unpack() {
	unpack ${A}
	cd ${S}; epatch ${FILESDIR}/X11-Protocol-0.51.s2.patch
}
