# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/anubis/anubis-3.6.2.ebuild,v 1.3 2003/07/13 13:32:32 aliz Exp $

DESCRIPTION="GNU Anubis is an outgoing mail processor."
HOMEPAGE="http://www.gnu.org/software/anubis/"
SRC_URI="mirror://gnu/anubis/${P}.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="x86"
IUSE="ssl pam tcpd crypt"

DEPEND="crypt? ( >=app-crypt/gpgme-0.3.13 )
	ssl?   ( >=dev-libs/openssl-0.9.6 )
	pam?   ( >=sys-libs/pam-0.75 )
	tcpd?  ( >=sys-apps/tcp-wrappers-7.6 )
	         >=dev-libs/libpcre-3.9"

S=${WORKDIR}/${P}

src_compile() {
	local myconf
	
	myconf="--with-pcre"
	
	use crypt || myconf="${myconf} --without-gpgme"
	use ssl  && myconf="${myconf} --with-openssl"
	use pam  && myconf="${myconf} --with-pam"
	use tcpd && myconf="${myconf} --with-tcp-wrappers"

	./configure ${myconf} --prefix=/usr --host=${CHOST} || die
	emake || die
}

src_install() {
	einstall
}

