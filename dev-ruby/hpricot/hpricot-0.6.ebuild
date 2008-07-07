# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/hpricot/hpricot-0.6.ebuild,v 1.4 2008/07/07 18:42:52 bluebird Exp $

inherit ruby gems

USE_RUBY="ruby18"

DESCRIPTION="A fast and liberal HTML parser for Ruby."
HOMEPAGE="http://code.whytheluckystiff.net/hpricot/"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~ppc64 ~sparc x86"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/ruby-1.8.4"
