# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/ruby-ldap/ruby-ldap-0.7.2.ebuild,v 1.2 2003/07/12 13:03:10 aliz Exp $

DESCRIPTION="A Ruby interface to some LDAP libraries"
HOMEPAGE="http://ruby-ldap.sourceforge.net/"
SRC_URI="mirror://sourceforge/ruby-ldap/${P}.tar.gz"
LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~arm ~hppa ~mips ~ppc ~sparc x86"
IUSE="ssl"
DEPEND=">=dev-lang/ruby-1.6
	>=net-nds/openldap-2
	ssl? ( dev-libs/openssl )"

src_compile() {
	ruby extconf.rb --with-openldap2
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc ChangeLog README* TODO
}
