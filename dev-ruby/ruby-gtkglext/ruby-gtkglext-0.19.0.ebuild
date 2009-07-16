# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gtkglext/ruby-gtkglext-0.19.0.ebuild,v 1.1 2009/07/16 08:06:48 graaff Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby GtkGLExt bindings"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""
USE_RUBY="ruby18"
DEPEND=">=x11-libs/gtkglext-1.0.3
	>=x11-libs/gtk+-2"
RDEPEND="dev-ruby/ruby-opengl
	dev-ruby/ruby-glib2
	dev-ruby/ruby-gtk2"
DEPEND="${DEPEND}
	dev-util/pkgconfig"
