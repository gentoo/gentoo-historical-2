# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gnomevfs/ruby-gnomevfs-0.15.0.ebuild,v 1.5 2008/03/30 15:28:33 armin76 Exp $

inherit ruby ruby-gnome2

DESCRIPTION="Ruby GnomeVFS bindings"
KEYWORDS="alpha ~amd64 ia64 ppc ~sparc ~x86"
IUSE=""
USE_RUBY="ruby18 ruby19"
DEPEND=">=gnome-base/gnome-vfs-2.2
	dev-util/pkgconfig"

src_test() {
	cd tests
	ruby -I../src/lib -I../src test1.rb || die "test1.rb failed"
	ruby -I../src/lib -I../src test2.rb || die "test2.rb failed"
	ruby -I../src/lib -I../src test3.rb || die "test3.rb failed"
}
