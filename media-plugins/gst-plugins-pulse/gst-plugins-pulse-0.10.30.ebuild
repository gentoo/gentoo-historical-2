# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-pulse/gst-plugins-pulse-0.10.30.ebuild,v 1.6 2011/10/11 19:44:09 jer Exp $

inherit gst-plugins-good

DESCRIPTION="GStreamer plugin for the PulseAudio sound server"
KEYWORDS="alpha amd64 arm hppa ia64 ~ppc ~ppc64 ~sh sparc x86"
IUSE=""

# >=0.9.20 is the latest suggested dep for some optional features/best behaviour not available before
RDEPEND=">=media-sound/pulseaudio-0.9.20
	>=media-libs/gst-plugins-base-0.10.33"
DEPEND="${RDEPEND}"
