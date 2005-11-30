# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/mysql-ruby/mysql-ruby-2.4.5.ebuild,v 1.1 2003/08/10 11:06:48 twp Exp $

DESCRIPTION="A Ruby extention library to use MySQL"
HOMEPAGE="http://www.tmtm.org/en/mysql/ruby/"
SRC_URI="http://www.tmtm.org/en/mysql/ruby/${P}.tar.gz"
LICENSE="Ruby"
SLOT="0"
KEYWORDS="alpha arm hppa mips ppc sparc x86"
IUSE=""
DEPEND=">=dev-lang/ruby-1.6.8
	>=dev-db/mysql-3.23.54"

src_compile() {
	ruby extconf.rb || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
}
