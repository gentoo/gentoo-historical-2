# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/rox-base/tasktray/tasktray-0.3.7-r1.ebuild,v 1.1 2006/11/20 20:25:46 lack Exp $

ROX_LIB_VER=1.9.6
inherit rox

MY_PN="TaskTray"
DESCRIPTION="TaskTray is a rox panel applet to show running applications."
HOMEPAGE="http://rox4debian.berlios.de"
SRC_URI="ftp://ftp.berlios.de/pub/rox4debian/apps/${MY_PN}-${PV}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

RDEPEND=">=dev-python/gnome-python-desktop-2.12"

APPNAME="${MY_PN}"
S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}"/${P}-theme_not_set.patch
}
