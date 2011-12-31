# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/hike/hike-1.2.1.ebuild,v 1.3 2011/12/31 19:47:18 grobian Exp $

EAPI=4
USE_RUBY="ruby18 ruby19 ree18 jruby"

RUBY_FAKEGEM_TASK_TEST="none"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="README.md"

inherit ruby-fakegem

DESCRIPTION="Hike is a Ruby library for finding files in a set of paths."
HOMEPAGE="https://github.com/sstephenson/hike"
LICENSE="MIT"
SRC_URI="https://github.com/sstephenson/hike/tarball/v${PV} -> ${P}.tgz"
RUBY_S="sstephenson-hike-*"

KEYWORDS="~amd64 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

each_ruby_test() {
	${RUBY} -Ilib:test -S testrb test || die
}
