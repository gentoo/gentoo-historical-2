# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/gst-plugins-pango/gst-plugins-pango-0.10.25.ebuild,v 1.2 2010/03/19 09:03:29 pacho Exp $

inherit gst-plugins-base

KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

# >=pango-1.15.4 to ensure vertical writing support
RDEPEND=">=x11-libs/pango-1.16"
DEPEND="${RDEPEND}"
