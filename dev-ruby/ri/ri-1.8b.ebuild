# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ri/ri-1.8b.ebuild,v 1.4 2004/02/22 22:23:46 agriffis Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Ruby Interactive reference"
HOMEPAGE="http://www.pragmaticprogrammer.com/ruby/downloads/ri.html"
SRC_URI="mirror://sourceforge/rdoc/${P}.tgz"

SLOT="0"
LICENSE="Ruby"
KEYWORDS="alpha hppa mips sparc x86"

DEPEND=">=dev-lang/ruby-1.8.0"

src_install () {
	dodoc COPYING ChangeLog README
	DESTDIR=${D} ruby install.rb
}
