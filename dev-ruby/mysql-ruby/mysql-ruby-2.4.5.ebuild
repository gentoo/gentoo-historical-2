# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mysql-ruby/mysql-ruby-2.4.5.ebuild,v 1.6 2005/03/08 18:26:52 caleb Exp $

DESCRIPTION="A Ruby extension library to use MySQL"
HOMEPAGE="http://www.tmtm.org/en/mysql/ruby/"
SRC_URI="http://www.tmtm.org/en/mysql/ruby/${P}.tar.gz"
LICENSE="Ruby"
SLOT="0"
KEYWORDS="alpha hppa mips ppc sparc x86"
IUSE=""
DEPEND="virtual/ruby
	>=dev-db/mysql-3.23.54"

src_compile() {
	ruby extconf.rb || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
