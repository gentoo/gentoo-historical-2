# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gstreamer/ruby-gstreamer-0.9.1.ebuild,v 1.6 2005/04/01 06:02:39 agriffis Exp $

inherit ruby-gnome2

DESCRIPTION="Ruby GStreamer bindings"
KEYWORDS="alpha x86 ~ia64 ~ppc"
IUSE=""
DEPEND="${DEPEND}
	>=gnome-base/libgnome-2.2
	>=gnome-base/libgnomeui-2.2"
RDEPEND="${RDEPEND}
	>=gnome-base/libgnome-2.2
	>=gnome-base/libgnomeui-2.2
	>=dev-ruby/ruby-gnomecanvas2-${PV}"
