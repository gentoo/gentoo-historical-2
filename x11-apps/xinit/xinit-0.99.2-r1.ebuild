# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xinit/xinit-0.99.2-r1.ebuild,v 1.1 2005/10/20 18:26:34 joshuabaergen Exp $

# Must be before x-modular eclass is inherited
# This is enabled due to modified Makefile.am from the patches
SNAPSHOT="yes"

inherit x-modular

DESCRIPTION="X.Org xinit application"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~s390 ~sh ~sparc ~x86"
RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

PATCHES="${FILESDIR}/nolisten-tcp-and-black-background.patch
	${FILESDIR}/gentoo-startx-customization.patch"

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
	newpamd ${FILESDIR}/xserver.pamd xserver
}
