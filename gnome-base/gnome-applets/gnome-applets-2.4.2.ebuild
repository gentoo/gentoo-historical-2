# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-applets/gnome-applets-2.4.2.ebuild,v 1.10 2004/06/24 21:56:03 agriffis Exp $

inherit gnome2

DESCRIPTION="Applets for the Gnome2 Desktop and Panel"
HOMEPAGE="http://www.gnome.org/"

IUSE="doc apm acpi ipv6"
SLOT="2"
LICENSE="GPL-2 FDL-1.1"
KEYWORDS="x86 ppc alpha sparc hppa amd64 ia64 mips"

RDEPEND=">=x11-libs/gtk+-2.1
	>=gnome-base/gail-1.3
	>=gnome-base/gconf-2.0
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libgtop-2
	>=gnome-base/gnome-panel-2
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	virtual/x11
	apm? ( sys-apps/apmd )
	!ppc? (	acpi? ( sys-apps/acpid ) )"
	# Virtual/x11 for XKB.h 

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=app-text/scrollkeeper-0.3.11
	doc? ( dev-util/gtk-doc )"

DOCS="AUTHORS ChangeLog COPYING COPYING-DOCS INSTALL NEWS README"
G2CONF="${G2CONF} $(use_enable ipv6)"

src_unpack() {
	unpack ${A}
	gnome2_omf_fix
}

src_install () {

	gnome2_src_install
	for BLERHG  in accessx-status battstat cdplayer charpick drivemount geyes gkb-new gtik gweather mailcheck mini-commander mixer modemlights multiload screen-exec stickynotes wireless; do
			docinto ${BLERHG}
			dodoc ${BLERHG}/[ChangeLog,AUTHORS,NEWS,TODO] ${BLERHG}/README*
	done

}
