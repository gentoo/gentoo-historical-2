# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-rrd/ruby-rrd-1.1.ebuild,v 1.2 2005/01/04 15:32:47 citizen428 Exp $

inherit ruby

IUSE=""
USE_RUBY="ruby18"

DESCRIPTION="Simple RRDTool wrapper for Ruby"
HOMEPAGE="http://people.ee.ethz.ch/~oetiker/webtools/rrdtool/"
SRC_URI="http://people.ee.ethz.ch/~oetiker/webtools/rrdtool/pub/contrib/${P}.tar.gz"

KEYWORDS="x86"
LICENSE="Ruby"
SLOT="0"

DEPEND="virtual/ruby
		>=net-analyzer/rrdtool-1.0.47"

src_compile() {
	ruby extconf.rb || die
	emake || die
}

src_install() {
	einstall || die
	dodoc README test.rb
}
