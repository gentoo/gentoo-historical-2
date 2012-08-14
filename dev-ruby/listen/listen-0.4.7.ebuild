# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/listen/listen-0.4.7.ebuild,v 1.2 2012/08/14 03:56:17 flameeyes Exp $

EAPI=4

USE_RUBY="ruby18 ruby19 ree18 jruby"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

RUBY_FAKEGEM_GEMSPEC="${PN}.gemspec"

inherit ruby-fakegem

DESCRIPTION="Listens to file modifications and notifies you about the changes."
HOMEPAGE="https://github.com/guard/listen"
SRC_URI="https://github.com/guard/listen/tarball/v${PV} -> ${P}-git.tgz"
RUBY_S="guard-listen-*"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

ruby_add_rdepend ">=dev-ruby/rb-inotify-0.8.8"

all_ruby_prepare() {
	# On Gentoo Linux we only support inotify.
	sed -i -e '/rb-fsevent/d' -e '/rb-fchange/d' ${RUBY_FAKEGEM_GEMSPEC} || die
}
