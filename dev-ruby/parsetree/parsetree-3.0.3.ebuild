# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/parsetree/parsetree-3.0.3.ebuild,v 1.3 2010/02/13 19:13:06 armin76 Exp $

inherit gems

MY_PN="ParseTree"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="ParseTree extracts the parse tree for a Class or method and returns it as a s-expression."
HOMEPAGE="http://www.zenspider.com/ZSS/Products/ParseTree/"
SRC_URI="http://gems.rubyforge.org/gems/${MY_P}.gem"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND=">=dev-ruby/ruby-inline-3.7.0
		>=dev-ruby/sexp-processor-3.0.0
		>=dev-ruby/hoe-1.8.0"

USE_RUBY="ruby18 ruby19"
