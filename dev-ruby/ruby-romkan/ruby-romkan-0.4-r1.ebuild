# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-romkan/ruby-romkan-0.4-r1.ebuild,v 1.13 2004/09/16 01:57:40 pvdabeel Exp $

inherit ruby

DESCRIPTION="A Romaji <-> Kana conversion library for Ruby"
HOMEPAGE="http://namazu.org/~satoru/ruby-romkan/"
SRC_URI="http://namazu.org/~satoru/ruby-romkan/${P}.tar.gz"
LICENSE="Ruby"
SLOT="0"
KEYWORDS="alpha hppa ~mips ppc sparc x86 ia64 macos amd64 ppc64 ppc-macos"
IUSE=""
DEPEND="virtual/ruby"

src_test() {
	./test.sh || die "test failed"
	rm test.rb
}
