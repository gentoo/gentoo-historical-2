# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-meta/gst-plugins-meta-0.10-r1.ebuild,v 1.2 2008/05/22 07:44:30 corsair Exp $

DESCRIPTION="Meta ebuild to pull in gst plugins for apps"
HOMEPAGE="http://www.gentoo.org"

LICENSE="GPL-2"
SLOT="0.10"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="alsa esd oss X xv dvb mythtv"

RDEPEND="oss? ( >=media-plugins/gst-plugins-oss-0.10 )
	alsa? ( >=media-plugins/gst-plugins-alsa-0.10 )
	esd? ( >=media-plugins/gst-plugins-esd-0.10 )
	X? ( >=media-plugins/gst-plugins-x-0.10 )
	xv? ( >=media-plugins/gst-plugins-xvideo-0.10 )
	dvb? ( media-plugins/gst-plugins-dvb
	       >=media-libs/gst-plugins-bad-0.10.6
		   >=media-plugins/gst-plugins-fluendo-mpegdemux-0.10.15 )
	mythtv? ( media-plugins/gst-plugins-mythtv )"

# Usage note:
# The idea is that apps depend on this for optional gstreamer plugins.  Then,
# when USE flags change, no app gets rebuilt, and all apps that can make use of
# the new plugin automatically do.

# When adding deps here, make sure the keywords on the gst-plugin are valid.
