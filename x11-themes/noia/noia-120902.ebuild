# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/noia/noia-120902.ebuild,v 1.1 2002/12/09 08:42:57 satai Exp $
inherit kde # not kde-base since we don't need c++ deps

need-kde 3

S="${WORKDIR}/noia"
DESCRIPTION="Noia Icon Set for KDE"
SRC_URI="http://www.ibiblio.org/gentoo/distfiles/${P}.tar.gz"
HOMEPAGE="http://www.carlitus.net"
KEYWORDS="~x86"
SLOT="0"
LICENSE="as-is"

# stripping hangs and we've no binaries
RESTRICT="$RESTRICT nostrip"

src_compile() {
	cd ${S}
	sed "s/Name=Noia KDE.*/Name=Noia Icon Snapshot ${PV}/" index.desktop > index.temp
	mv index.temp index.desktop
	return 1
}

src_install(){

	cd ${S}
	dodir $PREFIX/share/icons/
	cp -rf ${S} ${D}/${PREFIX}/share/icons/Noia-${PV}

}
