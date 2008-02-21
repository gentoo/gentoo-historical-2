# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-faac/gst-plugins-faac-0.10.6.ebuild,v 1.1 2008/02/21 12:02:50 zaheerm Exp $

inherit gst-plugins-bad

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

RDEPEND="media-libs/faac
	>=media-libs/gst-plugins-base-0.10.17
	>=media-libs/gstreamer-0.10.17"

DEPEND="${RDEPEND}"
