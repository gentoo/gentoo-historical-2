# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-faac/gst-plugins-faac-0.10.21.ebuild,v 1.5 2011/09/25 17:53:49 armin76 Exp $

inherit gst-plugins-bad

KEYWORDS="alpha amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="media-libs/faac
	>=media-libs/gst-plugins-base-0.10.32"
DEPEND="${RDEPEND}"
