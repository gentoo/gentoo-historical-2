# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-bdb/ruby-bdb-0.5.0.ebuild,v 1.1 2004/03/13 20:04:19 usata Exp $

inherit ruby

MY_P="${P/ruby-}"
DESCRIPTION="Ruby interface to Berkeley DB"
HOMEPAGE="http://moulon.inra.fr/ruby/bdb.html"
SRC_URI="ftp://moulon.inra.fr/pub/ruby/${MY_P}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~x86"
USE_RUBY="ruby16 ruby18 ruby19"

S=${WORKDIR}/${MY_P}

DEPEND="${DEPEND}
	>=sys-libs/db-3.2.9"

src_install() {
	ruby_src_install
	dodoc Changes
	dohtml bdb.html
}
