# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/rake-compiler/rake-compiler-0.7.0.ebuild,v 1.9 2010/04/30 20:29:13 graaff Exp $

EAPI=2
USE_RUBY="ruby18 ruby19 jruby"

RUBY_FAKEGEM_TASK_TEST="cucumber"

RUBY_FAKEGEM_DOCDIR="doc/api"
RUBY_FAKEGEM_EXTRADOC="History.txt README.rdoc"

inherit ruby-fakegem

DESCRIPTION="Provide a standard and simplified way to build and package Ruby extensions"
HOMEPAGE="http://github.com/luislavena/rake-compiler"
LICENSE="as-is" # truly

#SRC_URI="http://github.com/luislavena/${PN}/tarball/v${PV} -> ${P}.tar.gz"
SRC_URI="mirror://gentoo/${P}.tar.gz"
S="${WORKDIR}/luislavena-${PN}-2834041"

KEYWORDS="~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86"
SLOT="0"
IUSE=""

ruby_add_bdepend doc ">=dev-ruby/rdoc-2.4.3"
