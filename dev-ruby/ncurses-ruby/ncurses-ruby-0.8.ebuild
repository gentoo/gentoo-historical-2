# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ncurses-ruby/ncurses-ruby-0.8.ebuild,v 1.11 2004/10/14 19:49:02 dholm Exp $

inherit ruby

DESCRIPTION="Ruby wrappers of ncurses and PDCurses libs"
HOMEPAGE="http://ncurses-ruby.berlios.de/"
SRC_URI="http://download.berlios.de/ncurses-ruby/${P}.tar.bz2"
LICENSE="LGPL-2.1"
SLOT="0"
USE_RUBY="ruby16 ruby18 ruby19"
KEYWORDS="alpha ~hppa ~mips ~sparc x86 ~amd64 ~ppc"
IUSE=""
DEPEND="virtual/ruby
	>=sys-libs/ncurses-5.3"
