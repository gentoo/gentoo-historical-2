# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cucumber/cucumber-0.7.2.ebuild,v 1.3 2010/05/28 20:21:33 josejx Exp $

EAPI=2
USE_RUBY="ruby18"

# Documentation task depends on sdoc which we currently don't have.
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="spec cucumber"
RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Executable feature scenarios"
HOMEPAGE="http://github.com/aslakhellesoy/cucumber/wikis"
LICENSE="Ruby"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE="examples"

ruby_add_bdepend test ">=dev-ruby/rspec-1.3.0 >=dev-ruby/nokogiri-1.4.1"

ruby_add_rdepend "
	>=dev-ruby/builder-2.1.2
	>=dev-ruby/diff-lcs-1.1.2
	>=dev-ruby/gherkin-1.0.24
	>=dev-ruby/json-1.2.4
	>=dev-ruby/term-ansicolor-1.0.4
"

each_ruby_prepare() {
	# Remove features checking for optional dependencies that we currently
	# don't have in our tree.
	rm -f features/drb_server_integration.feature features/cucumber_cli.feature || die "Unable to remove unsupported features."
}

each_ruby_install() {
	each_fakegem_install

	ruby_fakegem_doins VERSION.yml
}

all_ruby_install() {
	all_fakegem_install

	if use examples; then
		cp -pPR examples "${D}/usr/share/doc/${PF}" || die "Failed installing example files."
	fi
}

pkg_postinst() {
	ewarn "Cucumber 0.7.x has minor parsing incompatibilities. Check the upgrade guide"
	ewarn "for details: http://wiki.github.com/aslakhellesoy/cucumber/upgrading"
}
