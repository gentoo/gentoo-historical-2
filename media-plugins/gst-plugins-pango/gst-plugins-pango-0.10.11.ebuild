# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-pango/gst-plugins-pango-0.10.11.ebuild,v 1.5 2007/01/30 07:05:00 jer Exp $

inherit gst-plugins-base

KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~sh sparc ~x86"
IUSE=""

RDEPEND="x11-libs/pango
	>=media-libs/gst-plugins-base-0.10.11"
DEPEND="${RDEPEND}"
