# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-mad/gst-plugins-mad-0.8.8.ebuild,v 1.11 2005/05/25 03:58:13 vapier Exp $

inherit gst-plugins

KEYWORDS="alpha amd64 arm hppa ia64 -mips ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=media-libs/libmad-0.15.0b
	>=media-libs/libid3tag-0.15"

DEPEND="${RDEPEND}
	dev-util/pkgconfig"
