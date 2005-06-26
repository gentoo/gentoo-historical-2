# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-libgda/ruby-libgda-0.10.1.ebuild,v 1.2 2005/06/26 15:42:17 usata Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby libgda (GNOME-DB) bindings"
KEYWORDS="x86 ~ppc ~alpha"
IUSE=""
USE_RUBY="ruby16 ruby18 ruby19"
DEPEND=">=gnome-extra/libgda-1.0.3"

src_test() {
	cd tests
	ruby tc_all.rb || die "tc_all.rb failed"
}
