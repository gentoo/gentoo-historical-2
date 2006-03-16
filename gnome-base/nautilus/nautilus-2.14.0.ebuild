# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/nautilus/nautilus-2.14.0.ebuild,v 1.1 2006/03/16 20:02:18 joem Exp $

inherit virtualx gnome2 eutils

DESCRIPTION="A file manager for the GNOME desktop"
HOMEPAGE="http://www.gnome.org/projects/nautilus/"

LICENSE="GPL-2 LGPL-2 FDL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="beagle gnome"
# cups flac gstreamer mad ogg vorbis

RDEPEND=">=media-libs/libart_lgpl-2.3.10
	>=gnome-base/libbonobo-2.1
	>=gnome-base/eel-2.13.91
	>=media-sound/esound-0.2.27
	>=dev-libs/glib-2.6
	>=gnome-base/gnome-desktop-2.9.91
	>=gnome-base/libgnome-2.1.1
	>=gnome-base/libgnomeui-2.6
	>=gnome-base/gnome-vfs-2.13.2
	>=gnome-base/orbit-2.4
	>=x11-libs/pango-1.1.2
	>=x11-libs/gtk+-2.6
	>=gnome-base/librsvg-2.0.1
	>=dev-libs/libxml2-2.4.7
	>=x11-libs/startup-notification-0.8
	>=media-libs/libexif-0.5.12
	>=gnome-base/gconf-2
	dev-libs/popt
	beagle? ( app-misc/beagle )
	|| ( (
		x11-libs/libICE
		x11-libs/libSM )
	virtual/x11 )
	virtual/eject"
#	!gstreamer? ( vorbis? ( media-sound/vorbis-tools ) )
#	gstreamer? (
#		>=media-libs/gstreamer-0.8
#		>=media-libs/gst-plugins-0.8
#		>=media-plugins/gst-plugins-gnomevfs-0.8
#		mad? ( >=media-plugins/gst-plugins-mad-0.8 )
#		ogg? ( >=media-plugins/gst-plugins-ogg-0.8 )
#		vorbis? ( >=media-plugins/gst-plugins-vorbis-0.8 )
#		flac? (	>=media-plugins/gst-plugins-flac-0.8 ) )"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.28
	>=dev-util/pkgconfig-0.9"

PDEPEND="x11-themes/gnome-themes
		 gnome? ( >=x11-themes/gnome-icon-theme-1.1.91 )"

DOCS="AUTHORS ChangeLog* HACKING MAINTAINERS NEWS README THANKS TODO"

pkg_setup() {
	G2CONF="${G2CONF} --disable-update-mimedb $(use_enable beagle)"
}

src_unpack() {
	unpack ${A}
	cd ${S}

	# disables launch of nautilus desktop on use of nautilus (Bug #69089)
	epatch ${FILESDIR}/${PN}-2.13.4-no-desktop.patch
}

src_test() {
	if hasq userpriv $FEATURES ;
	then
		Xmake check || die "Test phase failed"
	fi
}
