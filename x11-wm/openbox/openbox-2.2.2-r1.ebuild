# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/openbox/openbox-2.2.2-r1.ebuild,v 1.1 2002/12/08 21:27:38 mkeadle Exp $

IUSE="nls"

inherit commonbox

S=${WORKDIR}/${P}
DESCRIPTION="Window manager based on BlackBox - Development release"
SRC_URI="http://icculus.org/openbox/releases/${P}.tar.gz"
HOMEPAGE="http://icculus.org/openbox/"

SLOT="2"
LICENSE="BSD"
KEYWORDS="~x86"

DEPEND="sys-apps/supersed
		dev-util/pkgconfig"

MYBIN="${PN}-dev"
#FORCEXFT="1"
mydoc="CHANGE* TODO LICENSE data/README*"
myconf="--enable-xinerama"

src_install() {

	commonbox_src_install

	if (pkg-config xft)
	then
		rm -f ${D}/usr/share/man/man1/xftlsfonts*
	fi
	mv ${D}/usr/share/commonbox/openbox/epistrc \
		${D}/usr/share/commonbox/epistrc.default
	rmdir ${D}/usr/share/commonbox/${PN}
	rmdir ${D}/usr/share/commonbox/${MYBIN}

	insinto /usr/share/commonbox/buttons
	doins ${S}/data/buttons/*.xbm

}
