# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cucumber/cucumber-0.6.2.ebuild,v 1.1 2010/01/20 07:19:51 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="-f gem_tasks/rspec.rake spec"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="http://github.com/aslakhellesoy/cucumber/wikis"
LICENSE="Ruby"

KEYWORDS="~amd64 ~ppc ~x86"
SLOT="0"
IUSE="examples"

ruby_add_bdepend test "dev-ruby/rspec >=dev-ruby/nokogiri-1.4.1"

ruby_add_rdepend ">=dev-ruby/term-ansicolor-1.0.4
	>=dev-ruby/treetop-1.4.2
	>=dev-ruby/polyglot-0.2.9
	>=dev-ruby/diff-lcs-1.1.2
	>=dev-ruby/builder-2.1.2
	>=dev-ruby/json-1.2.0"

each_ruby_install() {
	each_fakegem_install

	ruby_fakegem_doins VERSION.yml
}

all_ruby_install() {
	ruby_fakegem_binwrapper cucumber
	dodoc History.txt README.rdoc

	if use examples; then
		cp -pPR examples "${D}/usr/share/doc/${PF}" || die "Failed installing example files."
	fi
}

pkg_postinst() {
	ewarn "Starting with cucumber 0.5.0 support for the Rails framework has been spun off."
	ewarn "Please install dev-util/cucumber-rails if you need support for Rails."
}
