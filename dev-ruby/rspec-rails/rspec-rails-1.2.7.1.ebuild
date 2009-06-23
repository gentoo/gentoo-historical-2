# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rspec-rails/rspec-rails-1.2.7.1.ebuild,v 1.1 2009/06/23 19:19:33 graaff Exp $

inherit gems

DESCRIPTION="RSpec's official Ruby on Rails plugin"
HOMEPAGE="http://rspec.info/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

USE_RUBY="ruby18"

RDEPEND=">=dev-ruby/rspec-1.2.7
	>=dev-ruby/rack-0.4.0
	>=dev-ruby/rubygems-1.3.0"
