# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-zoom/ruby-zoom-0.4.1.ebuild,v 1.1 2009/08/22 20:42:29 graaff Exp $

inherit gems

MY_P=${P/ruby-//}
S=${WORKDIR}/${MY_P}

IUSE=""

DESCRIPTION="A Ruby binding to the Z39.50 Object-Orientation Model (ZOOM)"
HOMEPAGE="http://ruby-zoom.rubyforge.org/"
SRC_URI="http://gems.rubyforge.org/gems/${MY_P}.gem"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~x86"

USE_RUBY="ruby18"

DEPEND="dev-libs/yaz"
RDEPEND="${DEPEND}"
