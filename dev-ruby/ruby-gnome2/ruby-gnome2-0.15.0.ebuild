# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gnome2/ruby-gnome2-0.15.0.ebuild,v 1.1 2006/08/30 11:18:09 pclouds Exp $

inherit ruby-gnome2

DESCRIPTION="Ruby Gnome2 bindings"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""
USE_RUBY="ruby18 ruby19"
DEPEND=">=gnome-base/libgnome-2.2
	>=gnome-base/libgnomeui-2.2"
RDEPEND=">=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-gtk2-${PV}
	>=dev-ruby/ruby-gnomecanvas2-${PV}"
