# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-system-monitor/gnome-system-monitor-2.0.0-r1.ebuild,v 1.7 2002/10/04 05:37:49 vapier Exp $


inherit gnome2



S=${WORKDIR}/${P}
DESCRIPTION="Procman - The Gnome System Monitor"
SRC_URI="mirror://gnome/2.0.0/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc sparc sparc64"
RDEPEND=">=x11-libs/gtk+-2.0.2
	>=gnome-base/libgnomeui-2.0.0
	>=gnome-base/libgnome-2.0.0
	>=gnome-base/gconf-1.1.11
	>=gnome-base/libgtop-2.0.0
	>=x11-libs/libwnck-0.12
	>=gnome-base/libgnomecanvas-2.0.0
	>=app-text/scrollkeeper-0.3.6"

DEPEND=">=dev-util/pkgconfig-0.12.0
	 >=dev-util/intltool-0.17
	 ${RDEPEND}"
	 
DOCS="AUTHORS ChangeLog COPYING HACKING README* INSTALL NEWS TODO"



