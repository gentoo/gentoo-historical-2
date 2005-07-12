# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/sqlite-ruby/sqlite-ruby-1.0.ebuild,v 1.9 2005/07/12 20:31:45 swegener Exp $

DESCRIPTION="An extension library to access a SQLite database from Ruby"
HOMEPAGE="http://sqlite-ruby.sourceforge.net/"
SRC_URI="mirror://sourceforge/sqlite-ruby/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha ~hppa ~mips ~ppc sparc ~x86"
IUSE=""
DEPEND=">=dev-lang/ruby-1.6.2
	=dev-db/sqlite-2*"
S=${WORKDIR}/sqlite

src_compile() {
	ruby extconf.rb || die
	emake || die
}

src_install() {
	einstall
}
