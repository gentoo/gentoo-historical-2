# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/origin/origin-1.0.1.ebuild,v 1.1 2012/06/21 12:43:34 flameeyes Exp $

EAPI=4

# does not support Ruby 1.8 syntax
USE_RUBY="ruby19" #jruby

#RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST=""

RUBY_FAKEGEM_EXTRADOC="README.md CHANGELOG.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

GITHUB_USER="mongoid"
GITHUB_PROJECT="${PN}"
RUBY_S="${GITHUB_USER}-${GITHUB_PROJECT}-*"

MY_PV="${PV/_rc/.rc}"

inherit ruby-fakegem

DESCRIPTION="Origin is a simple DSL for generating MongoDB selectors and options"
HOMEPAGE="http://mongoid.org/"
SRC_URI="https://github.com/${GITHUB_USER}/${GITHUB_PROJECT}/tarball/v${MY_PV} -> ${GITHUB_PROJECT}-${MY_PV}.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

ruby_add_bdepend "
	test? (
		>=dev-ruby/activesupport-3.1
		dev-ruby/rspec:2
		>=dev-ruby/i18n-0.6
		>=dev-ruby/tzinfo-0.3.22
	)"

DEPEND+=" test? ( dev-db/mongodb )"

all_ruby_prepare() {
	# remove references to bundler, as the gemfile does not add anything
	# we need to care about.
	sed -i -e '/[bB]undler/d' Rakefile || die
	# remove the Gemfile as well or it'll try to load it during testing
	rm Gemfile || die

	#epatch "${FILESDIR}"/${PN}-2.4.5-gentoo.patch
}

each_ruby_test() {
	mkdir "${T}/mongodb_$(basename $RUBY)"
	mongod --port 27017 --dbpath "${T}/mongodb_$(basename $RUBY)" \
		--noprealloc --noauth --nohttpinterface --nounixsocket --nojournal \
		--bind_ip 127.255.255.254 &
	mongod_pid=$!
	failed=0

	sleep 2

	export MONGOID_SPEC_HOST="127.255.255.254"
	export MONGOID_SPEC_PORT="27017"

	${RUBY} -S rake ${RUBY_FAKEGEM_TASK_TEST} || failed=1
	kill "${mongod_pid}"

	[[ "${failed}" == "1" ]] && die "tests failed"
}
