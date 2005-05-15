# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-plugins/wmbiff/wmbiff-0.4.25-r1.ebuild,v 1.3 2005/05/15 17:34:08 weeve Exp $

inherit eutils

DESCRIPTION="WMBiff is a dock applet for WindowMaker which can monitor up to 5 mailboxes."
SRC_URI="mirror://sourceforge/wmbiff/${P}.tar.gz"
HOMEPAGE="http://sourceforge.net/projects/wmbiff/"

DEPEND="virtual/x11
		crypt? ( >=net-libs/gnutls-1.0.4
			>=dev-libs/libgcrypt-1.1.94 )"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc sparc x86"
IUSE="crypt"

src_unpack()
{
	unpack ${A}
	cd ${S}
	if use crypt; then
		if has_version ">dev-libs/libgcrypt-1.1.12"; then
			epatch ${FILESDIR}/${P}-crypto-api-fix.patch
		fi
	fi
}

src_compile()
{
	local myconf
	if ! use crypt; then
			myconf="--disable-crypto"
	fi
	econf ${myconf} || die
	emake || die
}

src_install()
{
	make DESTDIR="${D}" install || die
	dodoc ChangeLog  FAQ NEWS  README  README.licq  TODO  wmbiff/sample.wmbiffrc
}
