# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-applets/gnome-applets-2.6.0-r1.ebuild,v 1.2 2004/05/20 23:53:33 foser Exp $

inherit gnome2 eutils

DESCRIPTION="Applets for the Gnome2 Desktop and Panel"
HOMEPAGE="http://www.gnome.org/"

IUSE="doc apm acpi ipv6 gstreamer"
SLOT="2"
LICENSE="GPL-2 FDL-1.1"
KEYWORDS="x86 ~ppc ~alpha ~sparc ~hppa ~amd64 ~ia64 ~mips"

RDEPEND=">=x11-libs/gtk+-2.1
	>=gnome-base/gail-1.3
	>=gnome-base/gconf-2.0
	>=gnome-base/gnome-vfs-2
	>=gnome-base/libgtop-2.5
	>=gnome-base/gnome-panel-2.5
	>=gnome-base/libglade-2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	>=x11-libs/libxklavier-0.97
	apm? ( sys-apps/apmd )
	acpi? ( sys-apps/acpid )
	gstreamer? ( >=media-libs/gstreamer-0.8 )"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	>=app-text/scrollkeeper-0.3.11
	doc? ( dev-util/gtk-doc )"

DOCS="AUTHORS ChangeLog COPYING COPYING-DOCS INSTALL NEWS README"

G2CONF="${G2CONF} $(use_enable ipv6) $(use_enable gstreamer) --enable-flags"

MAKEOPTS="${MAKEOPTS} -j1"

src_unpack() {

	unpack ${A}

	gnome2_omf_fix
	epatch ${FILESDIR}/gnome-applets-2.6.0-battstat.patch

	cd ${S}
	# fix weather reporting (#46389)
	epatch ${FILESDIR}/${P}-weather_icon_fix.patch
	# fix problem with alsa volume control (#50770)
	epatch ${FILESDIR}/${P}-fix_alsa_mixer.patch

}

src_install () {

	gnome2_src_install

	for BLERHG  in accessx-status battstat cdplayer charpick drivemount geyes gkb-new gtik gweather mailcheck mini-commander mixer modemlights multiload screen-exec stickynotes wireless; do
			docinto ${BLERHG}
			dodoc ${BLERHG}/[ChangeLog,AUTHORS,NEWS,TODO] ${BLERHG}/README*
	done

}

USE_DESTDIR="1"
