# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gtksourceview/ruby-gtksourceview-0.15.0.ebuild,v 1.2 2007/10/12 08:52:22 remi Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby bindings for gtksourceview"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""
USE_RUBY="ruby18 ruby19"
DEPEND="=x11-libs/gtksourceview-1*"
RDEPEND="${DEPEND}
	>=dev-ruby/ruby-gtk2-${PV}"
