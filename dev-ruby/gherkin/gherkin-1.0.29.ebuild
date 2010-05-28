# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/gherkin/gherkin-1.0.29.ebuild,v 1.3 2010/05/28 20:19:49 josejx Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC="-I lib rdoc"
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Fast Gherkin lexer and parser based on Ragel."
HOMEPAGE="http://wiki.github.com/aslakhellesoy/cucumber/gherkin"
LICENSE="MIT"

KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE=""

DEPEND="${DEPEND} dev-util/ragel"

ruby_add_bdepend test ">=dev-ruby/rspec-1.3.0 >=dev-util/cucumber-0.7.0"

ruby_add_rdepend ">=dev-ruby/trollop-1.16.2"

each_ruby_compile() {
	${RUBY} -I lib -S rake compile
}

each_ruby_test() {
	${RUBY} -S rake spec || die "Specs failed"
	CUCUMBER_HOME="${HOME}" ${RUBY} -S rake cucumber || die "Cucumber features failed"
}
