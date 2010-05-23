# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-activeldap/ruby-activeldap-1.2.1-r1.ebuild,v 1.1 2010/05/23 08:08:25 graaff Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES README TODO"
RUBY_FAKEGEM_EXTRAINSTALL="data po rails rails_generators"

inherit ruby-fakegem

MY_P="${P/ruby-/}"
DESCRIPTION="Ruby/ActiveLDAP provides an activerecord inspired object oriented interface to LDAP"
HOMEPAGE="http://ruby-activeldap.rubyforge.org/doc/"
SRC_URI="mirror://rubygems/${MY_P}.gem"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~x86"
IUSE=""

# Most tests require a live LDAP server to run.
RESTRICT="test"

ruby_add_bdepend "dev-ruby/hoe"
ruby_add_bdepend "test? ( virtual/ruby-test-unit )"

ruby_add_rdepend "
	~dev-ruby/activerecord-2.3.5
	~dev-ruby/locale-2.0.5
	~dev-ruby/ruby-gettext-2.1.0
	~dev-ruby/gettext_activerecord-2.1.0
	>=dev-ruby/ruby-ldap-0.8.2"

each_ruby_test() {
	# Tests use test-unit-2 which is currently masked in tree.
	# Version 2.0.6 is bundled so use that for now.
	RUBYLIB=test-unit/lib ${RUBY} -S rake test || die "Tests failed."
}

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r examples
}
