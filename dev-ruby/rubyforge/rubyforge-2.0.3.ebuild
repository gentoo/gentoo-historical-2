# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rubyforge/rubyforge-2.0.3.ebuild,v 1.5 2010/01/04 03:54:48 flameeyes Exp $

EAPI=2

USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt README.txt"

inherit ruby-fakegem

DESCRIPTION="Simplistic script which automates a limited set of rubyforge operations"
HOMEPAGE="http://codeforpeople.rubyforge.org/rubyforge/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86-fbsd"
IUSE=""

ruby_add_rdepend '>=dev-ruby/json-1.1.7'

ruby_add_bdepend test "virtual/ruby-test-unit dev-ruby/hoe"
ruby_add_bdepend doc dev-ruby/hoe

# JRuby-specific dependency
USE_RUBY="jruby" \
	ruby_add_bdepend 'test ruby_targets_jruby' dev-ruby/jruby-openssl
