# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/capistrano/capistrano-2.9.0.ebuild,v 1.5 2012/05/20 11:28:07 halcy0n Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.mdown"

inherit ruby-fakegem

DESCRIPTION="A distributed application deployment system"
HOMEPAGE="http://capify.org/"

LICENSE="MIT"
SLOT="2"
KEYWORDS="amd64 ppc ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/net-ssh-2.0.14
	>=dev-ruby/net-sftp-2.0.2
	>=dev-ruby/net-scp-1.0.2
	>=dev-ruby/net-ssh-gateway-1.1.0
	>=dev-ruby/highline-1.2.7"
ruby_add_bdepend "
	test? (	dev-ruby/mocha )"

all_ruby_prepare() {
	rm Gemfile || die
	sed -i -e '/[Bb]undler/d' Rakefile test/utils.rb || die
	sed -i -e '/ruby-debug/ s:^:#:' test/utils.rb || die

	# Comment out test failing to a similar namespace defined in new
	# versions of Rake, already fixed in newer versions of capistrano.
	rm test/recipes_test.rb || die

	# Avoid copy strategy tests since these fail in some cases due to
	# complicated (aka unknown) interactions with other parts of the
	# test suite.
	rm test/deploy/strategy/copy_test.rb || die
}
