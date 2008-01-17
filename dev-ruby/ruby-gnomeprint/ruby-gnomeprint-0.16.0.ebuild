# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gnomeprint/ruby-gnomeprint-0.16.0.ebuild,v 1.3 2008/01/17 16:04:05 flameeyes Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby bindings for gnomeprint"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""
USE_RUBY="ruby18 ruby19"
DEPEND=">=gnome-base/libgnomeprint-2.8"
RDEPEND="${DEPEND}
	>=dev-ruby/ruby-glib2-${PV}
	>=dev-ruby/ruby-pango-${PV}
	>=dev-ruby/ruby-libart2-${PV}"
DEPEND="${DEPEND}
	dev-util/pkgconfig"
