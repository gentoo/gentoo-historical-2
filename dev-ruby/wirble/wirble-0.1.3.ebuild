# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/wirble/wirble-0.1.3.ebuild,v 1.3 2009/08/09 00:26:30 tcunha Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="Wirble is a set of enhancements for Irb."
HOMEPAGE="http://pablotron.org/software/wirble/"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE=""

pkg_postinst() {
	elog "The quick way to use wirble is to make your ~/.irbrc look like this:"
	elog "  # load libraries"
	elog "  require 'rubygems'"
	elog "  require 'wirble'"
	elog "  "
	elog "  # start wirble (with color)"
	elog "  Wirble.init"
	elog "  Wirble.colorize"
}
