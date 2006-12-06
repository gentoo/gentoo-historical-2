# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/thunar/thunar-0.5.0_rc2.ebuild,v 1.3 2006/12/06 05:44:19 nichoj Exp $

inherit xfce44 versionator

xfce44_beta

MY_PN="Thunar"
MY_PV="$(replace_version_separator 3 '')"
MY_P="${MY_PN}-${MY_PV}"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Xfce 4 file manager"
HOMEPAGE="http://thunar.xfce.org"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

IUSE="dbus hal startup-notification thumbnail xslt"

RDEPEND="virtual/fam
	>=dev-libs/glib-2.6.4
	>=x11-libs/gtk+-2.6.4
	thumbnail? ( >=gnome-base/gconf-2.4 )
	gnome-base/orbit
	>=media-libs/jpeg-6b
	>=media-libs/libpng-1.2
	dbus? ( || 	( >=dev-libs/dbus-glib-0.71
				( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.34 ) )
	)
	hal? ( >=sys-apps/hal-0.5
		||	( >=dev-libs/dbus-glib-0.71
			( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.34 ) )
	)
	x11-libs/pango
	startup-notification? ( >=x11-libs/startup-notification-0.4 )
	xslt? ( dev-libs/libxslt )
	>=dev-util/gtk-doc-1
	>=x11-misc/shared-mime-info-0.15
	>=dev-util/desktop-file-utils-0.10
	>=xfce-base/libxfce4util-4.3.99.2
	>=xfce-extra/exo-0.3.1.12_rc2"

DEPEND="${RDEPEND}
	|| ( x11-proto/xproto virtual/x11 )"

XFCE_CONFIG="$(use_enable dbus) $(use_enable thumbnail gnome-thumbnailers) \
	$(use_enable startup-notification)"

if use xslt; then
	XFCE_CONFIG="${XFCE_CONFIG} --enable-xsltproc"
fi

if use hal; then
	XFCE_CONFIG="${XFCE_CONFIG} --with-volume-manager=hal"
else
	XFCE_CONFIG="${XFCE_CONFIG} --with-volume-manager=none"
fi
