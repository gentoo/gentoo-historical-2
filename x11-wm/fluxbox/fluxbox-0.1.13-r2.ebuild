# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/fluxbox/fluxbox-0.1.13-r2.ebuild,v 1.3 2003/02/13 17:47:44 vapier Exp $

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
filter-flags -fno-exceptions
export WANT_AUTOMAKE_1_6=1
export WANT_AUTOCONF_2_5=1

src_unpack() {

	unpack ${P}.tar.bz2
	cd ${S}
	patch -p1 < ${FILESDIR}/${P}-menukey.patch
	patch -p1 < ${FILESDIR}/${P}-aa2.patch
	patch -p1 < ${FILESDIR}/${P}-remember.patch
	patch -p1 < ${FILESDIR}/${P}-openoffice.patch
	patch -p0 < ${FILESDIR}/${P}-nls.patch

	# NLS is still names after blackbox. Remind me to talk to fluxgen about this.
	ssed -i "s:blackbox.cat:fluxbox.cat:" \
		${S}/src/main.cc
}

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
