# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/snmplib/snmplib-1.0.3.ebuild,v 1.1 2010/06/04 05:54:28 graaff Exp $

EAPI=2
USE_RUBY="ruby18"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="README"
RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

IUSE=""

MY_P="${P/snmplib/snmp}"

DESCRIPTION="SNMP library implemented in pure Ruby"
HOMEPAGE="http://snmplib.rubyforge.org/"
SRC_URI="mirror://rubygems/${MY_P}.gem"

KEYWORDS="~amd64 ~ia64 ~ppc ~x86"
LICENSE="Ruby"
SLOT="0"

ruby_add_bdepend "test? ( virtual/ruby-test-unit )"

all_ruby_install() {
	all_fakegem_install

	insinto /usr/share/doc/${PF}
	doins -r examples
}
