# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gtkglext/ruby-gtkglext-0.8.1.ebuild,v 1.5 2004/07/14 22:10:24 agriffis Exp $

inherit ruby-gnome2

DESCRIPTION="Ruby GtkGLExt bindings"
KEYWORDS="~alpha x86 ~ppc"
IUSE=""
DEPEND="virtual/ruby
	>=x11-libs/gtkglext-1.0.3
	>=x11-libs/gtk+-2
	dev-ruby/ruby-opengl
	dev-ruby/ruby-glib2
	dev-ruby/ruby-gtk2"
