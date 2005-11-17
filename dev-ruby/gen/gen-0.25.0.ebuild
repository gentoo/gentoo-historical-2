# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/gen/gen-0.25.0.ebuild,v 1.1 2005/11/17 17:22:12 citizen428 Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="A simple code generation system"
HOMEPAGE="http://www.nitrohq.com/"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.3
	=dev-ruby/glue-${PV}"
