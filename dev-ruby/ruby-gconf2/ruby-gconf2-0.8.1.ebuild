# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gconf2/ruby-gconf2-0.8.1.ebuild,v 1.5 2004/07/01 10:05:20 usata Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby GConf2 bindings"
KEYWORDS="alpha x86"
USE_RUBY="ruby16 ruby18 ruby19"
DEPEND="${DEPEND} >=gnome-base/gconf-2"
RDEPEND="${RDEPEND} >=gnome-base/gconf-2
	>=dev-ruby/ruby-glib2-${PV}"
