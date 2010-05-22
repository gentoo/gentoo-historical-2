# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/htmlentities/htmlentities-4.0.0.ebuild,v 1.4 2010/05/22 15:19:16 flameeyes Exp $

inherit ruby gems

USE_RUBY="ruby18"

DESCRIPTION="A simple library for encoding/decoding entities in (X)HTML documents."
HOMEPAGE="http://htmlentities.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.2"
RDEPEND="${DEPEND}"
