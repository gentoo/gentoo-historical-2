# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-inline/ruby-inline-3.8.4.ebuild,v 1.9 2010/05/22 23:08:53 a3li Exp $

EAPI=2

USE_RUBY="ruby18 ree18 ruby19"

RUBY_FAKEGEM_NAME="RubyInline"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.txt History.txt"

inherit ruby-fakegem

DESCRIPTION="Allows to embed C/C++ in Ruby code"
HOMEPAGE="http://www.zenspider.com/ZSS/Products/RubyInline/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

ruby_add_rdepend dev-ruby/zentest

ruby_add_bdepend "
	doc? (
		dev-ruby/hoe
		dev-ruby/hoe-seattlerb
	)
	test? (
		dev-ruby/hoe
		dev-ruby/hoe-seattlerb
		virtual/ruby-test-unit
	)"

all_ruby_install() {
	all_fakegem_install

	docinto examples
	dodoc example.rb example2.rb demo/*.rb || die
}
