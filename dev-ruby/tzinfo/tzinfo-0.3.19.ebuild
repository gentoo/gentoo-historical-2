# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/tzinfo/tzinfo-0.3.19.ebuild,v 1.1 2010/04/07 06:49:09 graaff Exp $

EAPI=2
USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGES README"

inherit ruby-fakegem

DESCRIPTION="Daylight-savings aware timezone library"
HOMEPAGE="http://tzinfo.rubyforge.org/"
SRC_URI="mirror://rubyforge/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=""
DEPEND=""

ruby_add_bdepend test virtual/ruby-test-unit

all_ruby_prepare() {
	# The package has all the files executable, probably coming from
	# Windows.
	find "${S}" -type f -perm +111 -exec chmod -x {} +

	# With rubygems 1.3.1 we get the following warning
	# warning: Insecure world writable dir /var/tmp in LOAD_PATH, mode 041777
	# when running the test_get_tainted_not_loaded test.
	sed -i -e '138,146s:^:#:' "${S}"/test/tc_timezone.rb || die "unable to sed out the test"
}
