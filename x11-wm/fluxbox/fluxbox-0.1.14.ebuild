# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/fluxbox/fluxbox-0.1.14.ebuild,v 1.1 2002/12/09 23:33:15 mkeadle Exp $

IUSE="nls"

inherit commonbox flag-o-matic

S=${WORKDIR}/${P}
DESCRIPTION="Window manager based on Blackbox and pwm -- has tabs."
SRC_URI="http://download.sourceforge.net/${PN}/${P}.tar.bz2"
HOMEPAGE="http://fluxbox.sf.net"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc ~sparc "

mydoc="ChangeLog COPYING NEWS"
myconf="--enable-xinerama"
if pkg-config xft
then
	CXXFLAGS="${CXXFLAGS} -I/usr/include/freetype2"
fi
filter-flags -fno-exceptions
#export WANT_AUTOMAKE_1_6=1
#export WANT_AUTOCONF_2_5=1

src_compile() {

	commonbox_src_compile

	cd data
	make \
		pkgdatadir=/usr/share/commonbox init
}


src_install() {

	commonbox_src_install
	cd data
	insinto /usr/share/commonbox
	doins init
	insinto /usr/share/commonbox/fluxbox
	doins keys
	rm -f ${D}/usr/bin/fluxbox-generate_menu
}
