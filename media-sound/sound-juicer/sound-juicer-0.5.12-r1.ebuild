# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/sound-juicer/sound-juicer-0.5.12-r1.ebuild,v 1.1 2004/07/21 00:27:24 eradicator Exp $

inherit gnome2

DESCRIPTION="CD ripper for GNOME 2"
HOMEPAGE="http://www.burtonini.com/blog/computers/sound-juicer/"
SRC_URI="http://www.burtonini.com/computing/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~ppc ~amd64"

IUSE="oggvorbis flac encode"

RDEPEND=">=dev-libs/glib-2
	>=gnome-base/libglade-2
	>=gnome-base/gconf-1.2
	>=gnome-base/libgnomeui-2
	>=media-libs/musicbrainz-2.0.1
	=media-libs/gstreamer-0.8*
	=media-plugins/gst-plugins-cdparanoia-0.8*
	oggvorbis? ( =media-plugins/gst-plugins-vorbis-0.8*
		=media-plugins/gst-plugins-ogg-0.8* )
	flac? ( =media-plugins/gst-plugins-flac-0.8* )
	encode? ( =media-plugins/gst-plugins-lame-0.8* )"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.29
	app-text/scrollkeeper
	dev-util/pkgconfig"

DOCS="AUTHORS COPYING ChangeLog INSTALL NEWS README TODO"

# needed to get around some sandboxing checks
export GST_INSPECT=/bin/true
