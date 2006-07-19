# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xinit/xinit-1.0.2-r6.ebuild,v 1.8 2006/07/19 09:31:18 gmsoft Exp $

# Must be before x-modular eclass is inherited
# This is enabled due to modified Makefile.am from the patches
SNAPSHOT="yes"

inherit x-modular pam

DESCRIPTION="X.Org xinit application"
KEYWORDS="alpha amd64 arm hppa ia64 mips ppc ppc64 ~s390 sh sparc x86 ~x86-fbsd"
IUSE="minimal"
RDEPEND="x11-libs/libX11
		!minimal? ( x11-wm/twm
		x11-apps/xclock
		x11-apps/xrdb )"
DEPEND="${RDEPEND}"
PDEPEND="x11-terms/xterm"
LICENSE="${LICENSE} GPL-2"

PATCHES="${FILESDIR}/nolisten-tcp-and-black-background.patch
	${FILESDIR}/gentoo-startx-customization-0.99.4.patch
	${FILESDIR}/${P}-setuid.diff"

src_unpack() {
	x-modular_unpack_source
	x-modular_patch_source

	sed -i -e "s:^XINITDIR.*:XINITDIR = \$(sysconfdir)/X11/xinit:g" ${S}/Makefile.am

	x-modular_reconf_source
}

src_install() {
	x-modular_src_install
	exeinto /etc/X11
	doexe ${FILESDIR}/chooser.sh ${FILESDIR}/startDM.sh
	exeinto /etc/X11/Sessions
	doexe ${FILESDIR}/Xsession
	exeinto /etc/X11/xinit
	doexe ${FILESDIR}/xinitrc
	newinitd ${FILESDIR}/xdm.start xdm
	newconfd ${FILESDIR}/xdm.confd xdm
	newpamd ${FILESDIR}/xserver.pamd xserver
}
