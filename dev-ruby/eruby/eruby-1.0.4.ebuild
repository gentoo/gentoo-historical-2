# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Maintaner: Tools Team <tools@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/eruby/eruby-1.0.4.ebuild,v 1.3 2004/02/22 22:21:25 agriffis Exp $

DESCRIPTION="eRuby interprets a Ruby code embedded text file"
HOMEPAGE="http://www.modruby.net/"
SRC_URI="http://www.modruby.net/archive/${P}.tar.gz"
LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha hppa mips sparc x86"
DEPEND=">=dev-lang/ruby-1.6"

src_compile() {
	ruby configure.rb || die
	make || die
}

src_install () {
	make DESTDIR=${D} install || die
	dodoc ChangeLog README*
}
