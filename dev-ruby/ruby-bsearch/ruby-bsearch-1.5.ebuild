# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-bsearch/ruby-bsearch-1.5.ebuild,v 1.4 2004/02/22 22:24:27 agriffis Exp $

DESCRIPTION="A binary search library for Ruby"
HOMEPAGE="http://namazu.org/~satoru/ruby-bsearch/"
SRC_URI="http://namazu.org/~satoru/ruby-bsearch/${P}.tar.gz"
LICENSE="Ruby"
SLOT="0"
KEYWORDS="~alpha ~hppa ~mips ~ppc ~sparc x86"
IUSE=""
DEPEND="dev-lang/ruby"

src_install() {
	local sitelibdir=`ruby -r rbconfig -e 'print Config::CONFIG["sitelibdir"]'`
	insinto ${sitelibdir}
	doins bsearch.rb
	dodoc ChangeLog *.rd bsearch.png
}
