# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/noia-warm/noia-warm-030209.ebuild,v 1.6 2004/06/19 13:30:08 pyrania Exp $

inherit kde

need-kde 3

S="${WORKDIR}/noia-warm"
DESCRIPTION="Noia Icon Set for KDE"
SRC_URI="http://www.ibiblio.org/gentoo/distfiles/${P}.tar.gz"
HOMEPAGE="http://www.carlitus.net"
KEYWORDS="x86 ppc"
SLOT="0"
LICENSE="as-is"
IUSE=""

# stripping hangs and we've no binaries
RESTRICT="$RESTRICT nostrip"

src_unpack() {
	unpack ${P}.tar.gz
}

src_compile() {
	cd ${WORKDIR}
	mv "Noia Warm KDE 0.95" "noia-warm"
	cd ${S}
	sed -i "s/Name=Noia Warm KDE.*/Name=Noia Warm Icon Snapshot ${PV}/" index.desktop
	return 1
}

src_install(){
	cd ${S}
	dodir $PREFIX/share/icons/
	cp -rf ${S} ${D}/${PREFIX}/share/icons/Noia-Warm-${PV}
}
