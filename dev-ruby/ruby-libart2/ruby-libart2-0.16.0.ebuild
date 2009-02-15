# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-libart2/ruby-libart2-0.16.0.ebuild,v 1.8 2009/02/15 14:17:12 flameeyes Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby Libart2 bindings"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""
USE_RUBY="ruby18"
DEPEND=">=media-libs/libart_lgpl-2
	>=dev-ruby/ruby-glib2-${PV}"
