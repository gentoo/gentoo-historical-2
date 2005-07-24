# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-amazon/ruby-amazon-0.9.0.ebuild,v 1.3 2005/07/24 22:34:44 citizen428 Exp $

inherit ruby

IUSE="geoip"

DESCRIPTION="A Ruby interface to Amazon web services"
HOMEPAGE="http://www.caliban.org/ruby/ruby-amazon.shtml"
SRC_URI="http://www.caliban.org/files/ruby/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

DEPEND="virtual/ruby
	geoip? ( >=dev-ruby/net-geoip-0.06 )"
USE_RUBY="ruby18"
