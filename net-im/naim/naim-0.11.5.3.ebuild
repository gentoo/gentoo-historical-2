# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/naim/naim-0.11.5.3.ebuild,v 1.1 2003/01/15 23:45:43 lostlogic Exp $

VA="`echo ${PV}|sed -e 's:^\([0-9]*\)\..*$:\1:'`"
VB="`echo ${PV}|sed -e 's:^[0-9]*\.\([0-9]*\)\..*$:\1:'`"
FOLDER="${P}"
SNAP=""
SRC_URI="http://128.113.139.111/~n/.${PN}_archive/${VA}/${VB}/${FOLDER}${SNAP}.tar.gz"
DESCRIPTION="An ncurses AOL Instant Messenger."
HOMEPAGE="http://site.rpi-acm.org/info/naim/"
#P="`echo ${P}|sed -e 's:_.*$::'`"
P="${P/_/}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

DEPEND=">=sys-libs/ncurses-5.2
	virtual/glibc"

S="${WORKDIR}/${P}"

src_compile() {
	einfo "${P}"

	local myconf
	myconf="--with-gnu-ld --enable-detach"
	use pic		&&	myconf="${myconf} --with-pic"
	use static	&&	myconf="${myconf} --enable-static=yes"

	econf ${myconf}	|| die "configure failed"
	emake		|| die "make failed"
}

src_install() {
	dobin src/naim

	doman naim.1

	dodoc AUTHORS BUGS ChangeLog FAQ NEWS README doc/*

	insinto /usr/share/${P}
	newins contrib/README.aimconvert README.aimconvert
	newins contrib/aimconvert.tcl aimconvert.tcl
	newins contrib/extractbuddy.sh extractbuddy.sh
	newins contrib/sendim.sh sendim.sh
	newins src/cmplhlp2.sh cmplhlp2.sh
	newins src/cmplhelp.sh cmplhelp.sh
	newins src/cmplsample.sh cmplsample.sh
	newins src/genkeys.sh genkeys.sh

	insinto /usr/include/${PN}
	newins include/modutil.h modutil.h
	newins include/naim.h naim.h
	newins include/config.h config.h
}
