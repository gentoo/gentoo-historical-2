# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/mkxf86config/mkxf86config-0.9.7.ebuild,v 1.2 2006/07/31 11:40:13 wolf31o2 Exp $

inherit eutils

DESCRIPTION="xorg-x11 configuration builder for Gentoo"
SRC_URI="http://dev.gentoo.org/~wolf31o2/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gentoo.org"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~alpha amd64 mips ~ppc x86"
IUSE=""

RDEPEND="!mips? ( sys-apps/hwsetup )"

src_install() {
	insinto /etc/X11
	if use mips
	then
		doins xorg.conf.impact xorg.conf.newport xorg.conf.o2-fbdev
	else
		doins xorg.conf.in
	fi
	exeinto /usr/sbin
	doexe mkxf86config.sh
	newinitd ${FILESDIR}/mkxf86config-init mkxf86config
}
