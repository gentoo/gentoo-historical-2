# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/facter/facter-1.6.0.ebuild,v 1.6 2011/10/09 17:25:48 xarthisius Exp $

EAPI="2"

USE_RUBY="ruby18 ruby19 ree18 jruby"
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_TASK_TEST="spec"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"
RUBY_FAKEGEM_BINWRAP="facter"

inherit ruby-fakegem

DESCRIPTION="A cross-platform Ruby library for retrieving facts from operating systems"
HOMEPAGE="http://www.puppetlabs.com/puppet/related-projects/facter/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""
KEYWORDS="amd64 hppa ppc ~ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x86-solaris"

ruby_add_bdepend "test? (
		dev-ruby/mocha
		dev-ruby/rspec:2
	)"
