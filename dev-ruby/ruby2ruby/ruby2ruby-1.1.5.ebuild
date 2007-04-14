# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby2ruby/ruby2ruby-1.1.5.ebuild,v 1.1 2007/04/14 00:01:56 robbat2 Exp $

inherit ruby gems

DESCRIPTION="Generates readable ruby from ParseTree"
HOMEPAGE="http://seattlerb.rubyforge.org/"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc ~x86 ~amd64"
IUSE=""

USE_RUBY="ruby18"

DEPEND="dev-ruby/parsetree
		>=dev-ruby/hoe-1.2.0"
