# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ri/ri-0.8a.ebuild,v 1.7 2003/03/25 20:58:25 seemant Exp $

S=${WORKDIR}/${PN}
DESCRIPTION="Ruby Interactive reference"
HOMEPAGE="http://www.pragmaticprogrammer.com/ruby/downloads/ri.html"
SRC_URI="http://www.pragmaticprogrammer.com/ruby/downloads/files/${P}.tgz"

SLOT="0"
LICENSE="Ruby"
KEYWORDS="x86 alpha"

DEPEND=">=dev-lang/ruby-1.6.2"

src_install () {
   dodoc COPYING ChangeLog README
   DESTDIR=${D} ruby install.rb
}
