# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/evilwm/evilwm-0.99.4.ebuild,v 1.9 2004/06/24 23:40:48 agriffis Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A minimalist, no frills window manager for X."
SRC_URI="http://download.sourceforge.net/evilwm/${PN}_${PV}-1.tar.gz"
HOMEPAGE="http://evilwm.sourceforge.net"

IUSE=""
SLOT="0"
LICENSE="as-is"
KEYWORDS="x86 sparc ppc"

DEPEND="virtual/x11
	virtual/glibc"

RDEPEND="$DEPEND"

src_compile() {
	emake allinone || die
}

src_install () {
	dodoc ChangeLog README*

	exeinto /usr/bin
	doexe evilwm

	doman evilwm.1
}

