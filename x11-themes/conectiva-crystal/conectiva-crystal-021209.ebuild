# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/conectiva-crystal/conectiva-crystal-021209.ebuild,v 1.9 2004/06/24 23:24:36 agriffis Exp $

inherit kde

need-kde 3

S="${WORKDIR}/crystal"
DESCRIPTION="Conectiva Crystal - Icon theme. Warning: included in >=kdeartwork-3.1!"
SRC_URI="http://www.ibiblio.org/gentoo/distfiles/${P}.tar.gz"
HOMEPAGE="http://www.conectiva.com.br"
KEYWORDS="x86 alpha ppc"
SLOT="0"
LICENSE="as-is"

# stripping hangs and we've no binaries
RESTRICT="$RESTRICT nostrip"

src_compile() {

	cd ${S}
	sed -i "s/Name=Conectiva Crystal .*/Name=Conectiva Crystal Snapshot ${PV}/" index.desktop
	return 1
}

src_install(){

	cd ${S}
	dodir $PREFIX/share/icons/
	cp -rf ${S} ${D}/${PREFIX}/share/icons/Crystal-${PV}

}

warning_msg() {

eerror "WARNING: this app is now part of kdeartwork-3.1. It is very much recommended that you"
eerror "upgrade to kde 3.1 instead of using this standalone package, because it is no longer being"
eerror "updated or fixed."
sleep 5

}

pkg_setup() {
	warning_msg
}

pkg_postinst() {
	warning_msg
}
