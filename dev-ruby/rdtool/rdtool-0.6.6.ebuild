# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Jerry Alexandratos <jerry@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rdtool/rdtool-0.6.6.ebuild,v 1.2 2001/11/10 12:17:54 hallski Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Fast string scanning library for Ruby"
SRC_URI="http://www2.pos.to/~tosh/ruby/rdtool/archive/${P}.tar.gz"
HOMEPAGE="http://www2.pos.to/~tosh/ruby/rdtool/en/index.html"

DEPEND=">=dev-lang/ruby-1.6.1
        >=dev-ruby/racc-1.2.4
        >=dev-ruby/strscan-0.5.8
        >=dev-ruby/optparse-0.7.5"

src_compile() {
	ruby rdtoolconf.rb || die
	make || die
}

src_install () {
	chmod 755 rd2
	dobin rd2

	cd ${S}/rd
	insinto /usr/lib/ruby/site_ruby/1.6/rd
	doins dot.rd2rc *.rb
}
