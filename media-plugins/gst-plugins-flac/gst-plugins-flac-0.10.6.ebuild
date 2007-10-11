# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-flac/gst-plugins-flac-0.10.6.ebuild,v 1.7 2007/10/11 14:59:22 corsair Exp $

inherit gst-plugins-good

KEYWORDS="alpha amd64 ~arm hppa ia64 ppc ppc64 ~sh ~sparc x86 ~x86-fbsd"

RDEPEND=">=media-libs/flac-1.1.2
	>=media-libs/gstreamer-0.10.13
	>=media-libs/gst-plugins-base-0.10.13"

DEPEND="${RDEPEND}"
