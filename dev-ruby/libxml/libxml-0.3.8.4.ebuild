# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/libxml/libxml-0.3.8.4.ebuild,v 1.4 2007/05/20 08:42:11 opfer Exp $

inherit ruby

MY_P=${PN}-ruby-${PV}
S="${WORKDIR}/${MY_P}"

DESCRIPTION="libxml for Ruby with a user friendly API, akin to REXML, but feature complete and significantly faster."
HOMEPAGE="http://libxml.rubyforge.org"
SRC_URI="http://rubyforge.org/frs/download.php/15237/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="doc"
USE_RUBY="ruby18 ruby19"

DEPEND="virtual/ruby
	dev-ruby/rake
	>=dev-libs/libxml2-2.6.6"

src_compile() {
	rake compile || die "rake compile failed"

	if use doc ; then
		rake doc || die "rake doc failed"
	fi
}

src_test() {
	rake test || die "rake test failed"
}

src_install() {
	rake install DESTDIR="${D}"

	dodoc CHANGELOG README

	if use doc ; then
		dohtml -r html/*
	fi
}
