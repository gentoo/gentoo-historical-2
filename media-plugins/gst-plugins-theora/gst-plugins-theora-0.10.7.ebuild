# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-theora/gst-plugins-theora-0.10.7.ebuild,v 1.4 2006/10/14 21:22:21 vapier Exp $

inherit gst-plugins-base

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sh ~sparc ~x86"
IUSE=""

RDEPEND=">=media-libs/libtheora-1.0_alpha3
	>=media-libs/libogg-1
	>=media-libs/gst-plugins-base-0.10.7"
DEPEND="${RDEPEND}"
