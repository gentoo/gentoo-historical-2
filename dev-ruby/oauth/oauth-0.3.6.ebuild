# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/oauth/oauth-0.3.6.ebuild,v 1.1 2009/09/20 07:27:25 graaff Exp $

inherit gems

DESCRIPTION="A RubyGem for implementing both OAuth clients and servers."
HOMEPAGE="http://rubyforge.org/projects/oauth/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

USE_RUBY="ruby18"

DEPEND=">=dev-ruby/ruby-hmac-0.3.1"
RDEPEND="${DEPEND}"
