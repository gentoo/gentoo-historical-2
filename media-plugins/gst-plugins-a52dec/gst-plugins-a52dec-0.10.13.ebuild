# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-a52dec/gst-plugins-a52dec-0.10.13.ebuild,v 1.4 2010/03/24 20:15:30 fauli Exp $

inherit gst-plugins-ugly

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND=">=media-libs/a52dec-0.7.3
	>=media-libs/gst-plugins-base-0.10.25
	>=media-libs/gstreamer-0.10.25"
DEPEND="${RDEPEND}"
