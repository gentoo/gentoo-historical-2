# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/openbox/openbox-2.2.1.ebuild,v 1.2 2003/02/13 08:11:20 gerk Exp $

IUSE="nls"

inherit commonbox

S=${WORKDIR}/${P}
DESCRIPTION="Window manager based on BlackBox - Development release"
SRC_URI="http://icculus.org/openbox/releases/${P}.tar.gz"
HOMEPAGE="http://icculus.org/openbox/"

SLOT="2"
LICENSE="BSD"
KEYWORDS="~x86 ppc"

MYBIN="${PN}-dev"
mydoc="CHANGE* TODO LICENSE data/README*"
myconf="--enable-xinerama"

src_unpack() {

	unpack ${P}.tar.gz
	ssed -i "s:xftlsfonts::" ${S}/util/Makefile.am
	ssed -i "s:xftlsfonts::" ${S}/util/Makefile.in

}
