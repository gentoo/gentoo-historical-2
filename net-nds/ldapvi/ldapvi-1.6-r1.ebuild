# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/ldapvi/ldapvi-1.6-r1.ebuild,v 1.1 2007/05/02 23:07:03 hansmi Exp $

inherit eutils

DESCRIPTION="Manage LDAP entries with a text editor"
HOMEPAGE="http://www.lichteblau.com/ldapvi/"
SRC_URI="http://www.lichteblau.com/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~x86"
IUSE="ssl"

DEPEND="
	sys-libs/ncurses
	>=net-nds/openldap-2.2
	dev-libs/popt
	>=dev-libs/glib-2
	sys-libs/readline
	ssl? ( dev-libs/openssl )
"

src_unpack() {
	unpack "${A}" || die
	cd "${S}"

	epatch "${FILESDIR}/${PV}-mem-corruption.diff"
}

src_compile() {
	econf $(use_with ssl libcrypto openssl) || die
	emake || die
}

src_install() {
	dobin ldapvi
	doman ldapvi.1
}
