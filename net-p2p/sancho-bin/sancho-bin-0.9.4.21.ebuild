# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/sancho-bin/sancho-bin-0.9.4.21.ebuild,v 1.4 2005/10/06 00:01:44 swegener Exp $

IUSE="gtk"

MY_P=${P/-bin/}
MY_P=${MY_P%.*}-${MY_P##*.}

use gtk && TOOLKIT="gtk" || TOOLKIT="fox"

DESCRIPTION="a powerful frontend for mldonkey"
HOMEPAGE="http://sancho-gui.sourceforge.net/"
SRC_URI="gtk? ( http://sancho-gui.sourceforge.net/dl/tmp94/${MY_P}-linux-gtk.tar.bz2 )
	!gtk? ( http://sancho-gui.sourceforge.net/dl/tmp94/${MY_P}-linux-fox.tar.bz2 )"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="CPL-1.0 LGPL-2.1"

DEPEND="virtual/libc
	virtual/x11
	gtk? ( >=x11-libs/gtk+-2
		>=net-libs/linc-1.0.3
		amd64? ( app-emulation/emul-linux-x86-gtklibs ) )"

S="${WORKDIR}/${MY_P}-linux-${TOOLKIT}"

ABI=x86

src_compile() {
	einfo "Nothing to compile."
}

src_install() {
	dodir /opt/sancho
	dodir /opt/bin

	cd ${S}
	cp -dpR sancho distrib lib ${D}/opt/sancho

	exeinto /opt/sancho
	doexe sancho-bin

	exeinto /opt/bin
	newexe ${FILESDIR}/sancho.sh sancho

	dodir /etc/env.d
	echo -e "PATH=/opt/sancho\n" > ${D}/etc/env.d/20sancho
}

pkg_postinst() {
	einfo
	einfo "Sancho requires the presence of a p2p core, like"
	einfo "net-p2p/mldonkey, in order to operate."
	einfo
}
