# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-panel-applet2/ruby-panel-applet2-0.19.0.ebuild,v 1.1 2009/07/16 08:56:30 graaff Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby Panel-applet bindings"
KEYWORDS="~amd64 ~ia64 ~sparc ~x86"
IUSE=""
USE_RUBY="ruby18"
DEPEND=">=gnome-base/gnome-panel-2.8
	=gnome-base/libgnome-2*
	=gnome-base/libgnomeui-2*"

RDEPEND="${DEPEND}
	>=dev-ruby/ruby-gnome2-${PV}
	>=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-gtk2-${PV}"
