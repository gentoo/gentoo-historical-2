# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/karamba-kroller/karamba-kroller-0.94.ebuild,v 1.5 2004/04/30 21:44:12 pvdabeel Exp $

IUSE=""
DESCRIPTION="Rolling menu plugin for Karamba"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=5931"
SRC_URI="http://www.kde-look.org/content/files/5931-kroller-v${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ppc"

RDEPEND=">=x11-misc/superkaramba-0.32"

src_unpack () {
	unpack ${A}
	mv kroller-v${PV} ${P}
}

src_install () {
	dodir /usr/share/karamba/themes/kroller
	sed -e 's#import karamba#import karamba\nimport os#' \
		-e 's#"/your/path/to/kroller.conf#os.environ["HOME"] + "/.karamba/kroller.conf#' \
		kroller.py > ${D}/usr/share/karamba/themes/kroller/kroller.py
	cp kroller.theme ${D}/usr/share/karamba/themes/kroller
	cp -r icons ${D}/usr/share/karamba/themes/kroller
	chmod -R go=u,go-w ${D}/usr/share/karamba/themes/kroller

	dodoc README CHANGELOG INSTALL kroller.conf
}
