# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/builder/builder-2.1.1.ebuild,v 1.10 2007/07/24 16:24:02 beandog Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="A builder to facilitate programatic generation of XML markup"
HOMEPAGE="http://rubyforge.org/projects/builder/"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.2"
