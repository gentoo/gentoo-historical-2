# Copyright 1999-2002 Gentoo Technologies, Inc.	  
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/app-arch/bsdsfv/bsdsfv-1.0.12.ebuild,v 1.7 2002/08/02 04:50:11 seemant Exp $

S=${WORKDIR}/bsdsfv
DESCRIPTION="BSDSFV: All-in-one SFV checksum utility"
SRC_URI="mirror://sourceforge/bsdsfv/${P}.tar.gz"
HOMEPAGE="http://bsdsfv.sourceforge.net/"

SLOT="0"
LICENSE="BSD"
KEYWORDS="x86"

DEPEND="virtual/glibc"

src_compile() {
	emake || die
}

src_install () {
	dobin bsdsfv
	dodoc README MANUAL
}
