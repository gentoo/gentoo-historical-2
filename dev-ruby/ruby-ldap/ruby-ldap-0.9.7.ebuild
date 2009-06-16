# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-ldap/ruby-ldap-0.9.7.ebuild,v 1.4 2009/06/16 19:28:53 fauli Exp $

inherit ruby

DESCRIPTION="A Ruby interface to some LDAP libraries"
HOMEPAGE="http://ruby-ldap.sourceforge.net/"
SRC_URI="mirror://sourceforge/ruby-ldap/${P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc sparc x86"
IUSE="ssl"
USE_RUBY="ruby18 ruby19"
DEPEND=">=dev-lang/ruby-1.8.2
	>=net-nds/openldap-2
	ssl? ( dev-libs/openssl )"

# Current test set is interactive due to certificate generation and requires
# running LDAP daemon
RESTRICT="test"

src_compile() {
	ruby extconf.rb --with-openldap2 || die "extconf.rb failed"
	emake || die
}

src_install() {
	emake -j1 DESTDIR="${D}" install || die
	dodoc ChangeLog README* TODO
}
