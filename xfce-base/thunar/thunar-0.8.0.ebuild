# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/xfce-base/thunar/thunar-0.8.0.ebuild,v 1.2 2007/01/23 16:57:24 welp Exp $

inherit xfce44

MY_P="${P/t/T}"
S="${WORKDIR}/${MY_P}"

xfce44
xfce44_extra_package # technically, it's core, but in terms of what the eclass
					 # does, it's more akin to 'extra' -nichoj

DESCRIPTION="Xfce4 file manager"
HOMEPAGE="http://thunar.xfce.org"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"

IUSE="doc dbus debug exif hal pcre startup-notification thumbnail trash-panel-plugin"

# The order of RDEPEND is based on the list in README, by:
# 	required packages
#	required packages not listed in README
#	optional packages
#   optional packages not listed
RDEPEND="
	>=dev-lang/perl-5.6
	>=x11-libs/gtk+-2.6.4
	>=dev-libs/glib-2.6.4
	>=xfce-extra/exo-0.3.2
	>=media-libs/libpng-1.2.0
	>=x11-misc/shared-mime-info-0.15
	>=dev-util/desktop-file-utils-0.10
	>=xfce-base/libxfce4util-${XFCE_MASTER_VERSION}
	virtual/fam
	doc? ( >=dev-util/gtk-doc-1 dev-libs/libxslt )
	dbus? ( || 	( >=dev-libs/dbus-glib-0.71
				( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.34 ) )
	)
	hal? ( >=sys-apps/hal-0.5
		||	( >=dev-libs/dbus-glib-0.71
			( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.34 ) )
	)
	>=media-libs/freetype-2.0
	thumbnail? ( >=gnome-base/gconf-2.4 )
	exif? ( >=media-libs/libexif-0.6 )
	>=media-libs/jpeg-6b
	startup-notification? ( >=x11-libs/startup-notification-0.4 )
	pcre? ( >=dev-libs/libpcre-6.0 )
	trash-panel-plugin? ( dbus? ( >=xfce-base/xfce4-panel-${XFCE_MASTER_VERSION} ) )"

DEPEND="${RDEPEND}
	dev-util/intltool
	x11-proto/xproto"

# TODO report upstream:
#	--enable/disable for jpeg
#	--enable/disable for freetype
# when those are fixed, we make IUSE="jpeg freetype"
XFCE_CONFIG="
	$(use_enable dbus) \
	$(use_enable doc gtk-doc) \
	$(use_enable doc xsltproc) \
	$(use_enable exif) \
	$(use_enable pcre) \
	$(use_enable startup-notification) \
	$(use_enable thumbnail gnome-thumbnailers) \
	"

if use hal; then
	XFCE_CONFIG="${XFCE_CONFIG} --with-volume-manager=hal"
else
	XFCE_CONFIG="${XFCE_CONFIG} --with-volume-manager=none"
fi

use trash-panel-plugin && use dbus || XFCE_CONFIG="${XFCE_CONFIG} --disable-tpa-plugin"

pkg_setup() {
	if use trash-panel-plugin && ! use dbus ; then
		ewarn "trash-panel-plugin requires ${PN} with dbus support"
		ewarn "Enable dbus use flag and re-emerge this ebuild if you want this feature."
		epause 3
	fi
}
