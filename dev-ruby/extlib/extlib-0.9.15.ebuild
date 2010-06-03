# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/extlib/extlib-0.9.15.ebuild,v 1.1 2010/06/03 05:38:33 graaff Exp $

EAPI="2"
USE_RUBY="ruby18"

RUBY_FAKEGEM_TASK_DOC="yard"
RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README.rdoc"
RUBY_FAKEGEM_TASK_TEST="-f tasks/spec.rake spec"

inherit ruby-fakegem

DESCRIPTION="Support library for DataMapper and Merb"
HOMEPAGE="http://extlib.rubyforge.org"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

ruby_add_bdepend "doc? ( dev-ruby/yard )"
ruby_add_bdepend "test? ( >=dev-ruby/json-1.4.0 >=dev-ruby/rspec-1.3.0 )"

each_ruby_prepare() {
	sed -i '/check_dependencies/d' tasks/spec.rake || die "Unable to remove check_dependencies rules."
}
