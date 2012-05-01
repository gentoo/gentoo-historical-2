# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/test-spec/test-spec-0.10.0-r2.ebuild,v 1.16 2012/05/01 18:24:05 armin76 Exp $

EAPI="2"

USE_RUBY="ruby18 ree18 jruby"

RUBY_FAKEGEM_EXTRADOC="README SPECS ROADMAP TODO"
RUBY_FAKEGEM_DOCDIR="doc"

inherit ruby-fakegem eutils

DESCRIPTION="A library to do Behavior Driven Development with Test::Unit"
HOMEPAGE="http://chneukirchen.org/blog/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

ruby_add_rdepend virtual/ruby-test-unit
ruby_add_bdepend test dev-ruby/mocha

all_ruby_prepare() {
	epatch "${FILESDIR}"/${P}-jruby.patch
}

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc examples/* || die
}
