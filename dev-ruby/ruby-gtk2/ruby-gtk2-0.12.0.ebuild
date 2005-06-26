# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gtk2/ruby-gtk2-0.12.0.ebuild,v 1.2 2005/06/26 15:30:03 usata Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby Gtk2 bindings"
KEYWORDS="~alpha x86 ~ppc ~ia64 ~sparc ~amd64"
IUSE=""
USE_RUBY="ruby16 ruby18 ruby19"
DEPEND=">=x11-libs/gtk+-2"
RDEPEND="${DEPEND}
	>=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-gdkpixbuf2-${PV}
	>=dev-ruby/ruby-pango-${PV}
	>=dev-ruby/ruby-atk-${PV}"
