# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/pdf-writer/pdf-writer-1.1.7.ebuild,v 1.2 2008/02/12 18:47:12 opfer Exp $

inherit ruby gems

DESCRIPTION="A pure Ruby PDF document creation library."
HOMEPAGE="http://rubyforge.org/projects/ruby-pdf/"
SRC_URI="http://gems.rubyforge.org/gems/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-ruby/color-1.4.0
	>=dev-ruby/transaction-simple-1.3.0"
