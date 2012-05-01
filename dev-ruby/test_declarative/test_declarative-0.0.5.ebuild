# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/test_declarative/test_declarative-0.0.5.ebuild,v 1.6 2012/05/01 18:24:13 armin76 Exp $

EAPI=4

USE_RUBY="ruby18 ree18 jruby ruby19 rbx"

RUBY_FAKEGEM_TASK_TEST=""
RUBY_FAKEGEM_TASK_DOC=""

RUBY_FAKEGEM_EXTRADOC="README.textile"

inherit ruby-fakegem

DESCRIPTION="Simply adds a declarative test method syntax to test/unit."
HOMEPAGE="https://github.com/svenfuchs/test_declarative"
SRC_URI="https://github.com/svenfuchs/test_declarative/tarball/v${PV} -> ${P}.tgz"
RUBY_S="svenfuchs-test_declarative-*"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"
IUSE=""

each_ruby_test() {
	${RUBY} test/test_declarative_test.rb || die "Tests failed."
}
