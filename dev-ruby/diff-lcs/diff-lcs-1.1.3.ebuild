# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/diff-lcs/diff-lcs-1.1.3.ebuild,v 1.4 2012/07/15 12:48:46 ago Exp $

EAPI=2
USE_RUBY="ruby18 ree18 ruby19 jruby"

RUBY_FAKEGEM_TASK_TEST="spec"

RUBY_FAKEGEM_TASK_DOC="docs"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc History.rdoc"

inherit ruby-fakegem

DESCRIPTION="Use the McIlroy-Hunt LCS algorithm to compute differences"
HOMEPAGE="https://github.com/halostatue/diff-lcs"

LICENSE="|| ( MIT Ruby GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "test? ( >=dev-ruby/hoe-2.10 dev-ruby/rspec:2 )"

all_ruby_prepare() {
	# Remove unneeded rspec require to avoid rspec with USE=doc.
	sed -i -e "/require 'rspec'/d" Rakefile || die
}
