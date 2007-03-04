# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/IO-Reactor/IO-Reactor-0.0.6.ebuild,v 1.4 2007/03/04 19:47:26 tgall Exp $

RUBY_BUG_145222=yes
inherit ruby

DESCRIPTION="IO Reactor for event-driven multiplexed IO in a single thread"
HOMEPAGE="http://www.deveiate.org/projects/IO-Reactor/"
SRC_URI="http://www.deveiate.org/code/${P}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86-fbsd ~x86"
IUSE="examples"

DEPEND=""
RDEPEND=""

src_compile() {
	return 0 # Nothing to do
}

src_install() {
	insinto "$(${RUBY} -r rbconfig -e 'print Config::CONFIG["sitelibdir"]')/io"
	doins lib/io/reactor.rb

	erubydoc
}
