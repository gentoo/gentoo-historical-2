# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-mmap/ruby-mmap-0.2.2.ebuild,v 1.4 2003/11/15 17:48:20 usata Exp $

inherit ruby

IUSE=""

MY_P=${P/ruby-/}

DESCRIPTION="The Mmap class implement memory-mapped file objects"
HOMEPAGE="http://moulon.inra.fr/ruby/mmap.html"
SRC_URI="ftp://moulon.inra.fr/pub/ruby/${MY_P}.tar.gz"

SLOT="0"
USE_RUBY="1.6 1.8"
LICENSE="Ruby"
KEYWORDS="x86 alpha ppc sparc"

DEPEND="dev-ruby/rdoc"

S=${WORKDIR}/${MY_P}

src_compile() {

	ruby_src_compile all rdoc || die
}
