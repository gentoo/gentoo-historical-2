# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gconf2/ruby-gconf2-0.16.0.ebuild,v 1.7 2008/10/06 14:36:36 graaff Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby GConf2 bindings"
KEYWORDS="alpha amd64 ia64 ~ppc sparc x86"
IUSE=""
USE_RUBY="ruby18 ruby19"
DEPEND=">=gnome-base/gconf-2
	dev-util/pkgconfig"
RDEPEND=">=gnome-base/gconf-2
	>=dev-ruby/ruby-glib2-${PV}"
