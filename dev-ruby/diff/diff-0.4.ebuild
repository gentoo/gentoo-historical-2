# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/diff/diff-0.4.ebuild,v 1.2 2004/09/03 00:33:39 dholm Exp $

inherit ruby

DESCRIPTION="Computes the differences between two arrays of elements"
HOMEPAGE="http://users.cybercity.dk/~dsl8950/ruby/diff.html"
#SRC_URI="http://users.cybercity.dk/~dsl8950/ruby/${P}.tar.gz"
SRC_URI="http://www.rubynet.org/mirrors/diff/${P}.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc"

IUSE=""

src_install() {
	ruby_src_install
	docinto samples
	dodoc samples/*.rb
}

src_test() {
	cd test
	ruby test_diff.rb || die "test_diff.rb failed."
}
