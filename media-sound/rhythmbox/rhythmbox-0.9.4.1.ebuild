# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/rhythmbox/rhythmbox-0.9.4.1.ebuild,v 1.5 2006/11/19 20:17:00 cardoe Exp $

inherit gnome2 eutils

DESCRIPTION="Music management and playback software for GNOME"
HOMEPAGE="http://www.rhythmbox.org/"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="hal vorbis flac aac mad ipod avahi howl daap dbus libnotify musicbrainz
tagwriting python"
#I want tagwriting to be on by default in the future. It is just a local flag
#now because it is still considered experimental by upstream and doesn't work
#well with all formats

SLOT="0"

RDEPEND=">=x11-libs/gtk+-2.5.4
	>=gnome-base/libgnomeui-2
	>=gnome-base/libglade-2
	>=gnome-base/gnome-vfs-2.7.4
	>=gnome-base/libbonobo-2
	>=gnome-extra/nautilus-cd-burner-2.9.0
	>=media-video/totem-1.1.5
	musicbrainz? ( >=media-libs/musicbrainz-2.1 )
	>=net-libs/libsoup-2.2
	hal? ( ipod? ( >=media-libs/libgpod-0.2.0
			>=sys-apps/hal-0.5 ) )
	avahi? ( >=net-dns/avahi-0.6 )
	!avahi? ( howl? ( >=net-misc/howl-0.9.8 ) )
	dbus? ( || ( >=dev-libs/dbus-glib-0.71
			( <sys-apps/dbus-0.90 >=sys-apps/dbus-0.35 ) ) )
	>=media-libs/gst-plugins-base-0.10
	>=media-plugins/gst-plugins-gnomevfs-0.10
	vorbis? ( >=media-plugins/gst-plugins-vorbis-0.10
				>=media-plugins/gst-plugins-ogg-0.10 )
	mad? ( >=media-plugins/gst-plugins-mad-0.10 )
	flac? ( >=media-plugins/gst-plugins-flac-0.10 )
	aac? ( >=media-plugins/gst-plugins-faad-0.10 )
	libnotify? ( >=x11-libs/libnotify-0.3.2 )
	python? ( >=dev-lang/python-2.4.2
				>=dev-python/pygtk-2.6 )"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=dev-util/intltool-0.29
	app-text/scrollkeeper"

MAKEOPTS="${MAKEOPTS} -j1"

S=${WORKDIR}/${MY_P}

pkg_setup() {

	if ! use avahi && ! use howl; then
		if use daap ; then
		ewarn "Daap support requires either howl or avahi"
		ewarn "to be installed. Please remerge with either"
		ewarn "USE=avahi or USE=howl"
		fi
	fi
	if use howl || use avahi ; then
		G2CONF="${G2CONF} $(use_enable daap)"
	fi

	if use howl ; then
		G2CONF="${G2CONF} --with-mdns=howl"
	fi

	if use avahi ; then
		G2CONF="${G2CONF} --with-mdns=avahi"
	fi

	G2CONF="${G2CONF} \
	$(use_enable tagwriting tag-writing) \
	$(use_enable ipod) \
	$(use_enable musicbrainz) \
	$(use_with dbus) \
	$(use_enable python) \
	$(use_enable libnotify) \
	--with-playback=gstreamer-0-10 \
	--enable-mmkeys \
	--enable-audioscrobbler \
	--with-metadata-helper \
	--disable-schemas-install"

DOCS="AUTHORS COPYING ChangeLog DOCUMENTERS INSTALL INTERNALS \
	  MAINTAINERS NEWS README README.iPod THANKS TODO"

export GST_INSPECT=/bin/true
USE_DESTDIR=1
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/rhythmbox-0.9.4_p1-libnotify.patch
	}
