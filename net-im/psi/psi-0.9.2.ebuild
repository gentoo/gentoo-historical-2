# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/psi/psi-0.9.2.ebuild,v 1.9 2005/01/04 20:32:14 humpback Exp $

IUSE="kde ssl crypt"
RESTRICT="nomirror"
QV="2.0"
SRC_URI="mirror://sourceforge/psi/${P}.tar.bz2"
DESCRIPTION="QT 3.x Jabber Client, with Licq-like interface"
HOMEPAGE="http://psi.affinix.com"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ppc hppa amd64"

DEPEND="ssl? ( >=dev-libs/openssl-0.9.6c >=app-crypt/qca-tls-1.0 )
	crypt? ( >=app-crypt/gnupg-1.2.2 )
	>=x11-libs/qt-3"

src_compile() {
	use kde || myconf="${myconf} --disable-kde"
	./configure --prefix=/usr $myconf || die
	addwrite "$HOME/.qt"
	addwrite "$QTDIR/etc/settings"
	emake || die
}

src_install() {
	dodoc README TODO
	make INSTALL_ROOT="${D}" install
}
