# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-zlib/ruby-zlib-0.6.0.ebuild,v 1.3 2003/11/03 15:49:09 usata Exp $

inherit ruby

IUSE=""

DESCRIPTION="Extension library to use zlib from Ruby"
HOMEPAGE="http://www.blue.sky.or.jp/atelier/ruby/"
SRC_URI="http://www.blue.sky.or.jp/atelier/ruby/${P}.tar.gz"

SLOT="0"
RUBY_SLOT="0"
LICENSE="Ruby"
KEYWORDS="x86 alpha ~ppc sparc"

DEPEND="sys-libs/zlib"
