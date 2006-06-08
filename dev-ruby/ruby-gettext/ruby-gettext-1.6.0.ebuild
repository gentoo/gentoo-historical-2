# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-gettext/ruby-gettext-1.6.0.ebuild,v 1.1 2006/06/08 17:24:44 flameeyes Exp $

inherit ruby gems

MY_P=${P/ruby-/}
DESCRIPTION="Ruby GetText Package is Native Language Support Library and Tools which modeled after GNU gettext package"
HOMEPAGE="http://ponx.s5.xrea.com/hiki/ruby-gettext.html"
# The source tarball was downloaded from the site above
SRC_URI="http://gems.rubyforge.org/gems/${MY_P}.gem"


KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""
USE_RUBY="ruby18"
SLOT="0"
LICENSE="Ruby"

DEPEND="virtual/ruby
	sys-devel/gettext
	dev-ruby/rdtool
	>=dev-ruby/racc-1.4.4"

S="${WORKDIR}/${PN}-package-${PV}"
