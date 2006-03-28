# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-pango/ruby-pango-0.14.1.ebuild,v 1.4 2006/03/28 23:44:20 agriffis Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby Pango bindings"
KEYWORDS="~alpha ~amd64 ia64 ppc ~sparc x86"
IUSE=""
USE_RUBY="ruby18 ruby19"
DEPEND=">=x11-libs/pango-1.2.1"
RDEPEND="${DEPEND}
	>=dev-ruby/ruby-glib2-${PV}"
