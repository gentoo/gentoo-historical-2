# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-bdb/ruby-bdb-0.5.3.ebuild,v 1.4 2005/12/23 20:25:48 hansmi Exp $

inherit ruby

MY_P="${P/ruby-}"
DESCRIPTION="Ruby interface to Berkeley DB"
HOMEPAGE="http://moulon.inra.fr/ruby/bdb.html"
SRC_URI="ftp://moulon.inra.fr/pub/ruby/${MY_P}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ppc sparc x86"
IUSE=""
USE_RUBY="ruby16 ruby18 ruby19"

S=${WORKDIR}/${MY_P}

DEPEND=">=sys-libs/db-3.2.9"

src_install() {
	ruby_src_install
	dodoc Changes
	dohtml bdb.html
}
