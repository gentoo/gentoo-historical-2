# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-libglade2/ruby-libglade2-0.8.0.ebuild,v 1.5 2004/07/14 22:13:45 agriffis Exp $

inherit ruby-gnome2

DESCRIPTION="Ruby Libglade2 bindings"
KEYWORDS="alpha x86 ia64"
IUSE="gnome"
DEPEND="${DEPEND} >=gnome-base/libglade-2"
RDEPEND="${RDEPEND} >=gnome-base/libglade-2
	gnome? ( >=dev-ruby/ruby-gnome2-${PV} )
	!gnome? ( >=dev-ruby/ruby-gtk2-${PV} )"
