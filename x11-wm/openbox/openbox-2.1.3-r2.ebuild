# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header

inherit commonbox

S=${WORKDIR}/${P}
DESCRIPTION="Window manager based on BlackBox"
SRC_URI="http://icculus.org/${PN}/releases/${P}.tar.gz"
HOMEPAGE="http://icculus.org/${PN}"

SLOT="1"
LICENSE="BSD"
KEYWORDS="x86 sparc sparc64"

DEPEND="sys-apps/supersed"

MYBIN="${PN}"
mydoc="CHANGE* TODO LICENSE data/README*"
myconf="--enable-xinerama"
BOOTSTRAP="1"

src_unpack() {
   unpack ${A}
   ssed -i "s:XftValueList:FcValueList:" \
		${S}/util/xftlsfonts.cc
}

src_install() {

	commonbox_src_install

	mv ${D}/usr/share/commonbox/openbox/epistrc \
		${D}/usr/share/commonbox/epistrc.default
	rmdir ${D}/usr/share/commonbox/openbox
}
