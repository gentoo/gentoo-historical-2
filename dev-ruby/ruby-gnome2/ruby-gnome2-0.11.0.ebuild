# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gnome2/ruby-gnome2-0.11.0.ebuild,v 1.3 2005/06/26 15:36:58 usata Exp $

inherit ruby-gnome2

DESCRIPTION="Ruby Gnome2 bindings"
KEYWORDS="~alpha x86 ~ia64 ~ppc ~sparc ~amd64"
IUSE=""
DEPEND=">=gnome-base/libgnome-2.2
	>=gnome-base/libgnomeui-2.2"
RDEPEND="${DEPEND}
	>=dev-ruby/ruby-gnomecanvas2-${PV}"
