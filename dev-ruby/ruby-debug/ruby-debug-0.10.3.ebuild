# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-debug/ruby-debug-0.10.3.ebuild,v 1.5 2010/07/17 17:23:09 armin76 Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="CLI interface to ruby-debug"
HOMEPAGE="http://rubyforge.org/projects/ruby-debug/"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="=dev-ruby/ruby-debug-base-0.10.3
	>=dev-ruby/columnize-0.1
	>=dev-lang/ruby-1.8.4"
RDEPEND="${DEPEND}"
