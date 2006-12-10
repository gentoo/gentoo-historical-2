# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-extra/terminal/terminal-0.2.5.8_rc2.ebuild,v 1.3 2006/12/10 20:33:32 nichoj Exp $

inherit gnome2 xfce44 versionator

xfce44_beta

MY_PN="Terminal"
MY_PV="$(replace_version_separator 4 '')"
MY_P="${MY_PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Terminal for Xfce 4"
SRC_URI="http://www.xfce.org/archive/xfce-${XFCE_MASTER_VERSION}/src/${MY_P}${COMPRESS}"
HOMEPAGE="http://www.xfce.org"
LICENSE="LGPL-2"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

IUSE="dbus startup-notification xslt"

RDEPEND=">=dev-libs/glib-2
	>=x11-libs/gtk+-2.6
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libpng
	dbus? ( || 	( >=dev-libs/dbus-glib-0.71
				( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.34 ) )
	)
	|| ( ( x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXrender )
	virtual/x11 )
	startup-notification? ( >=x11-libs/startup-notification-0.5 )
	>=x11-libs/vte-0.11.11
	xslt? ( dev-libs/libxslt )
	>=xfce-extra/exo-0.3.1.12_rc2"

XFCE_CONFIG="$(use_enable startup-notification) $(use_enable dbus)"

if use xslt; then
	XFCE_CONFIG="${XFCE_CONFIG} --enable-xsltproc"
fi

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
