# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/syntax/syntax-1.0.0.ebuild,v 1.5 2007/04/13 21:02:50 robbat2 Exp $

inherit ruby gems

DESCRIPTION="Syntax highlighting for sourcecode and html"
HOMEPAGE="http://syntax.rubyforge.org"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="BSD"
SLOT="0"
KEYWORDS="ia64 x86 ~ppc ~amd64"
IUSE=""

USE_RUBY="any"
DEPEND="virtual/ruby"
