# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-applets/gnome-applets-2.2.1.ebuild,v 1.6 2003/07/09 16:12:09 liquidx Exp $

IUSE="doc"

inherit libtool gnome2

S=${WORKDIR}/${P}
DESCRIPTION="Applets for the Gnome2 Desktop and Panel"
HOMEPAGE="http://www.gnome.org/"
SLOT="2"
LICENSE="GPL-2 FDL-1.1" 
KEYWORDS="x86 ppc ~alpha ~sparc hppa"

RDEPEND=">=x11-libs/gtk+-2.1
	>=x11-libs/libwnck-0.13
	>=gnome-base/gail-0.13
	>=gnome-base/gconf-1.2.1
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libgtop-2
	>=gnome-base/gnome-panel-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	>=app-text/scrollkeeper-0.3.11"
	
DEPEND=">=dev-util/pkgconfig-0.12.0
	doc? ( dev-util/gtk-doc )
	${RDEPEND}"

G2CONF="--disable-install-schemas --enable-platform-gnome-2 --enable-panelmenu=yes"

src_unpack() {
	unpack ${A}
	gnome2_omf_fix
}

src_install() {
	gnome2_src_install
    
	dodoc AUTHORS ChangeLog COPYING* README* INSTALL NEWS message-of-doom 
	docinto battstat
	dodoc battstat/AUTHORS battstat/ChangeLog battstat/README battstat/TODO
	docinto cdplayer
	dodoc cdplayer/ChangeLog
	docinto charpic
	dodoc charpic/ChangeLog
	docinto drivemount
	dodoc drivemount/AUTHORS drivemount/ChangeLog
	docinto geyes
	dodoc geyes/AUTHORS geyes/ChangeLog geyes/NEWS geyes/README*
	docinto gkb-new
	dodoc gkb-new/AUTHORS gkb-new/ChangeLog gkb-new/README gkb-new/TODO
	docinto gtik
	dodoc gtik/AUTHORS gtik/README gtik/ChangeLog gtik/NEWS
	docinto gweather
	dodoc gweather/AUTHORS gweather/ChangeLog gweather/NEWS gweather/README gweather/TODO
	docinto mini-commander
	dodoc mini-commander/AUTHORS mini-commander/ChangeLog mini-commander/NEWS mini-commander/README mini-commander/TODO
	docinto mixer
	dodoc mixer/AUTHORS mixer/ChangeLog
	docinto modemlights
	dodoc modemlights/AUTHORS modemlights/ChangeLog modemlights/TODO
	docinto multiload
	dodoc multiload/AUTHORS multiload/ChangeLog
}
