# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/amrita/amrita-1.8.2-r1.ebuild,v 1.7 2004/05/02 16:13:20 fmccor Exp $

inherit ruby

IUSE=""

DESCRIPTION="A HTML/XHTML template library for Ruby"
HOMEPAGE="http://www.brain-tokyo.jp/research/amrita/index.html"
SRC_URI="http://www.brain-tokyo.jp/research/amrita/${P}.tar.gz"
LICENSE="Ruby"
SLOT="0"
USE_RUBY="ruby16 ruby18 ruby19"
KEYWORDS="alpha ~hppa ~mips sparc x86 ~ppc"
DEPEND="|| ( >=dev-lang/ruby-1.8.0
	dev-ruby/shim-ruby18
	dev-lang/ruby-cvs )"
