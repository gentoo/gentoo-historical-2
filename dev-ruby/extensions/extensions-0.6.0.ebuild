# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/extensions/extensions-0.6.0.ebuild,v 1.6 2007/10/14 04:23:56 tgall Exp $

inherit ruby gems

USE_RUBY="ruby18"
DESCRIPTION="Extensions to the standard Ruby library"
HOMEPAGE="http://rubyforge.org/projects/extensions/"
# The URL depends implicitly on the version, unfortunately. Even if you
# change the filename on the end, it still downloads the same file.
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="ia64 ppc64 x86"
IUSE=""

DEPEND=">=dev-lang/ruby-1.8.2"
