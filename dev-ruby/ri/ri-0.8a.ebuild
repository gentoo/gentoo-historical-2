# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ri/ri-0.8a.ebuild,v 1.2 2002/07/11 06:30:24 drobbins Exp $

S="${WORKDIR}/ri"
DESCRIPTION="Ruby Interactive reference"
SRC_URI="http://www.pragmaticprogrammer.com/ruby/downloads/files/${P}.tgz"
HOMEPAGE="http://www.pragmaticprogrammer.com/ruby/downloads/ri.html"
LICENSE="Ruby"
KEYWORDS="x86"
SLOT="0"

DEPEND=">=dev-lang/ruby-1.6.2" # Specified in ${HOMEPAGE}

src_unpack () {
   unpack ${A}
   cd ${S}
}

src_install () {
   dodoc COPYING ChangeLog README
   DESTDIR=${D} ruby install.rb
}
