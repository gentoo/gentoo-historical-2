# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-inline/ruby-inline-3.7.0.ebuild,v 1.1 2008/10/06 16:21:44 graaff Exp $

inherit gems

MY_P="RubyInline-${PV}"
DESCRIPTION="Allows to embed C/C++ in Ruby code"
HOMEPAGE="http://www.zenspider.com/ZSS/Products/RubyInline/"
SRC_URI="http://gems.rubyforge.org/gems/${MY_P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=dev-ruby/hoe-1.5.3"

USE_RUBY="ruby18 ruby19"
