# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/mail-client/elmo/elmo-1.3.1-r1.ebuild,v 1.1 2004/08/06 13:00:05 citizen428 Exp $
IUSE="crypt nls ssl"

DESCRIPTION="Elmo: console email client"
HOMEPAGE="http://elmo.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"

KEYWORDS="~x86"
SLOT="0"

DEPEND="ssl? ( >=dev-libs/openssl )"
RDEPEND="nls? ( sys-devel/gettext )
	crypt? ( =app-crypt/gpgme-0.4.7 )"


src_compile() {
	local myconf

	use nls \
		|| myconf="--disable-nls"

	use ssl \
		|| mycconf="${myconf} --without-openssl"

	econf ${myconf} || die
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die
	dodoc ABOUT-NLS ADVOCACY AUTHORS BUGS COPYING ChangeLog INSTALL NEWS THANKS TODO doc/*
}
