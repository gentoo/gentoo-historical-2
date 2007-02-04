# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-inline/ruby-inline-3.6.2.ebuild,v 1.1 2007/02/04 04:10:05 pclouds Exp $

inherit ruby gems

MY_P="RubyInline-${PV}"
DESCRIPTION="Allows to embed C/C++ in Ruby code"
HOMEPAGE="http://www.zenspider.com/ZSS/Products/RubyInline/"
SRC_URI="http://gems.rubyforge.org/gems/${MY_P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

USE_RUBY="ruby18"

DEPEND=">=dev-lang/ruby-1.8.4
	>=dev-ruby/hoe-1.1.1"
