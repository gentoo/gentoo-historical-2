# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-libart2/ruby-libart2-0.9.1.ebuild,v 1.6 2004/07/03 11:28:55 slarti Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby Libart2 bindings"
KEYWORDS="~alpha x86 ~ppc ~ia64 ~sparc ~amd64"
USE_RUBY="ruby16 ruby18 ruby19"
DEPEND="${DEPEND} >=media-libs/libart_lgpl-2"
RDEPEND="${RDEPEND} >=media-libs/libart_lgpl-2"
