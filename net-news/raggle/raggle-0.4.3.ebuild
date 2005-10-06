# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-news/raggle/raggle-0.4.3.ebuild,v 1.1 2005/10/06 13:05:36 caleb Exp $

inherit ruby

IUSE=""

DESCRIPTION="A console RSS aggregator, written in Ruby"
HOMEPAGE="http://www.raggle.org/"
SRC_URI="http://www.raggle.org/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~sparc ~x86"

USE_RUBY="ruby18 ruby19"
DEPEND="|| ( >=dev-lang/ruby-1.8
	dev-lang/ruby-cvs )"
RDEPEND=">=dev-ruby/ncurses-ruby-0.8"

src_unpack() {
	unpack ${A}
	cd ${S}

	sed -i -e 's~/usr/local~${D}/usr~' \
		-e '/cp -r \${DOCS}/d' \
		-e "/^DOCDIR/ s/raggle/${PF}/" \
		Makefile || die "sed failed"
}
