# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Maintaner: Tools Team <tools@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/eruby/eruby-1.0.5.ebuild,v 1.4 2004/05/02 16:24:49 fmccor Exp $

inherit ruby

IUSE=""

DESCRIPTION="eRuby interprets a Ruby code embedded text file"
HOMEPAGE="http://www.modruby.net/"
SRC_URI="http://www.modruby.net/archive/${P}.tar.gz"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~hppa ~mips sparc x86 ~ppc"
DEPEND="virtual/ruby"
USE_RUBY="ruby16 ruby18"	# doesn't build on ruby19

src_compile() {
	ruby configure.rb || die
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc ChangeLog README*
}
