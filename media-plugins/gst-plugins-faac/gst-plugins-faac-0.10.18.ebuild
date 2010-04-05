# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-faac/gst-plugins-faac-0.10.18.ebuild,v 1.1 2010/04/05 23:49:43 leio Exp $

inherit gst-plugins-bad

KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="media-libs/faac
	>=media-libs/gst-plugins-base-0.10.27"
DEPEND="${RDEPEND}"
