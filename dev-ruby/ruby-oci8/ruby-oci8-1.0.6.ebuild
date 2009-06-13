# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-oci8/ruby-oci8-1.0.6.ebuild,v 1.1 2009/06/13 07:23:15 graaff Exp $

inherit ruby

DESCRIPTION="A Ruby library for Oracle"
HOMEPAGE="http://rubyforge.org/projects/ruby-oci8/"
SRC_URI="mirror://rubyforge/${PN}/${P}.tar.gz"

LICENSE="Ruby"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

USE_RUBY="ruby18 ruby19"

RDEPEND="dev-db/oracle-instantclient-basic
	dev-db/oracle-instantclient-sqlplus
	virtual/ruby"
DEPEND="${RDEPEND}"

src_compile() {
	emake -j1 CONFIG_OPT="--prefix=${D}usr" config.save setup || die $!
}

src_install() {
	emake DESTDIR="${D}" install || die
}
