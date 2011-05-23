# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-mimic/gst-plugins-mimic-0.10.21.ebuild,v 1.2 2011/05/23 08:57:34 phajdan.jr Exp $

inherit gst-plugins-bad

DESCRIPTION="GStreamer plugin for the MIMIC codec"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/gst-plugins-base-0.10.32
	>=media-libs/libmimic-1.0.4"
DEPEND="${RDEPEND}"
