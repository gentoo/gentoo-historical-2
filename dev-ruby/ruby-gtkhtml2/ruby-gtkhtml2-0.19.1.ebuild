# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gtkhtml2/ruby-gtkhtml2-0.19.1.ebuild,v 1.3 2010/01/10 18:13:15 nixnut Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby GtkHtml2 bindings"
KEYWORDS="amd64 ~ia64 ppc ~sparc x86"
IUSE=""
USE_RUBY="ruby18"
RDEPEND="=gnome-extra/gtkhtml-2*
	>=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-gtk2-${PV}"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}/ruby-gnome2-all-${PV}/gtkhtml2"
