# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/facets/facets-0.6.3.ebuild,v 1.4 2005/10/08 13:14:32 citizen428 Exp $

inherit ruby gems

IUSE=""

USE_RUBY="ruby18"
DESCRIPTION="Facets is an extension library adding extra functionality to Ruby"
HOMEPAGE="http://www.rubyonrails.org"

SRC_URI="http://rubyforge.org/frs/download.php/4016/${P}.gem"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~ppc x86"

DEPEND="=dev-lang/ruby-1.8*"

