# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

inherit ruby

DESCRIPTION="Ruby wrappers of ncurses and PDCurses libs"
HOMEPAGE="http://ncurses-ruby.berlios.de/"
SRC_URI="mirror://berlios/${PN}/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
USE_RUBY="ruby18 ruby19"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="examples"
DEPEND=">=sys-libs/ncurses-5.3"
