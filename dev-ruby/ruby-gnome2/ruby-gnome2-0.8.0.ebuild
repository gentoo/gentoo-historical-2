# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gnome2/ruby-gnome2-0.8.0.ebuild,v 1.1 2003/11/18 13:13:42 agriffis Exp $

inherit ruby-gnome2

DESCRIPTION="Ruby Gnome2 bindings"
KEYWORDS="~alpha ~x86"
DEPEND="${DEPEND} >=gnome-base/libgnome-2.2 >=gnome-base/libgnomeui-2.2"
RDEPEND="${RDEPEND} >=gnome-base/libgnome-2.2 >=gnome-base/libgnomeui-2.2
	>=dev-ruby/ruby-gnomecanvas2-${PV}"
