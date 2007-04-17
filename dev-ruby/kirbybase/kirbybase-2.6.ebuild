# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/kirbybase/kirbybase-2.6.ebuild,v 1.1 2007/04/17 12:37:53 agorf Exp $

inherit ruby gems

USE_RUBY="ruby18"
MY_P="KirbyBase-${PV}"

DESCRIPTION="A simple Ruby DBMS that stores data in plaintext files."
HOMEPAGE="http://www.netpromi.com/kirbybase_ruby.html"
SRC_URI="http://gems.rubyforge.org/gems/${MY_P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~ia64 ~ppc64 ~x86"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.2"
RDEPEND="${DEPEND}"
