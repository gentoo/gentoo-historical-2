# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/hoe/hoe-2.4.0.ebuild,v 1.6 2010/01/04 11:12:17 fauli Exp $

EAPI=2
USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_TASK_DOC="docs"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="History.txt Manifest.txt README.txt"

RUBY_FAKEGEM_EXTRAINSTALL="template"

inherit ruby-fakegem

DESCRIPTION="Hoe extends rake to provide full project automation."
HOMEPAGE="http://seattlerb.rubyforge.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE=""

# also requires dev-ruby/hoe-seattlerb for 1.9
ruby_add_bdepend test virtual/ruby-minitest

ruby_add_rdepend ">=dev-ruby/rake-0.8.7 >=dev-ruby/rubyforge-2.0.3"

all_ruby_prepare() {
	epatch "${FILESDIR}"/${P}-tests.patch
}
