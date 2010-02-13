# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/sexp-processor/sexp-processor-3.0.3.ebuild,v 1.3 2010/02/13 19:08:20 armin76 Exp $

inherit gems

MY_PN="sexp_processor"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Processor for s-expressions created as part of the ParseTree project."
HOMEPAGE="http://www.zenspider.com/ZSS/Products/ParseTree/"
SRC_URI="http://gems.rubyforge.org/gems/${MY_P}.gem"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

USE_RUBY="ruby18 ruby19"
