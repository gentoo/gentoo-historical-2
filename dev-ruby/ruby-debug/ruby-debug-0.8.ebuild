# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-debug/ruby-debug-0.8.ebuild,v 1.2 2007/04/13 21:15:29 robbat2 Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="CLI interface to ruby-debug"
HOMEPAGE="http://rubyforge.org/projects/ruby-debug/"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="ruby-debug"
KEYWORDS="~amd64 ~ppc ~x86"

DEPEND="=dev-ruby/ruby-debug-base-0.8
	>=dev-lang/ruby-1.8.4"
RDEPEND="${DEPEND}"
