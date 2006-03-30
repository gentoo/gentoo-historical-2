# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-zoom/ruby-zoom-0.2.0.ebuild,v 1.4 2006/03/30 03:55:25 agriffis Exp $

inherit ruby

IUSE=""

DESCRIPTION="A Ruby binding to the Z39.50 Object-Orientation Model (ZOOM)"
HOMEPAGE="http://ruby-zoom.rubyforge.org/"
SRC_URI="http://rubyforge.org/frs/download.php/5601/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"

DEPEND="virtual/ruby
	dev-libs/yaz"

USE_RUBY="ruby18"
