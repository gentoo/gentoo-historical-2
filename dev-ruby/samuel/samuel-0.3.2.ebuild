# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/samuel/samuel-0.3.2.ebuild,v 1.1 2010/01/13 09:18:25 flameeyes Exp $

EAPI=2

# jruby → tests need fakeweb
USE_RUBY="ruby18 ruby19"

RUBY_FAKEGEM_TASK_DOC=""

inherit ruby-fakegem

DESCRIPTION="An automatic logger for HTTP requests in Ruby."
HOMEPAGE="http://github.com/chrisk/samuel"

LICENSE="as-is" # truly
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_bdepend test "dev-ruby/shoulda dev-ruby/fakeweb"
