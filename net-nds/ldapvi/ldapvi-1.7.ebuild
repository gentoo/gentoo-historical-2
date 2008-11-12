# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-nds/ldapvi/ldapvi-1.7.ebuild,v 1.6 2008/11/12 13:11:44 fmccor Exp $

inherit eutils

DESCRIPTION="Manage LDAP entries with a text editor"
HOMEPAGE="http://www.lichteblau.com/ldapvi/"
SRC_URI="http://www.lichteblau.com/download/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 hppa ppc ~sparc x86"
IUSE="ssl"

RDEPEND="sys-libs/ncurses
	>=net-nds/openldap-2.2
	dev-libs/popt
	>=dev-libs/glib-2
	sys-libs/readline
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	econf $(use_with ssl libcrypto openssl) || die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dobin ldapvi || die "dobin failed"
	doman ldapvi.1
}
