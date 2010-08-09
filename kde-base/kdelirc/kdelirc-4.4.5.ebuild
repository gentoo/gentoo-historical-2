# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdelirc/kdelirc-4.4.5.ebuild,v 1.4 2010/08/09 07:15:06 fauli Exp $

EAPI="3"

KMNAME="kdeutils"
inherit kde4-meta

DESCRIPTION="KDE frontend for the Linux Infrared Remote Control system"
KEYWORDS="amd64 ppc x86"
IUSE="debug +handbook"

DEPEND="
	$(add_kdebase_dep solid)
"
RDEPEND="${DEPEND}
	!kde-misc/kdelirc
	app-misc/lirc
"

src_prepare() {
	kde4-meta_src_prepare

	sed -e 's:${KDE4WORKSPACE_SOLIDCONTROL_LIBRARY}:solidcontrol:g' \
		-i kdelirc/{kcmlirc,kdelirc,irkick}/CMakeLists.txt \
		|| die "sed failed"
}
