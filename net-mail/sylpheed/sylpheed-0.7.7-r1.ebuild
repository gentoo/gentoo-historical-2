# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/net-mail/sylpheed/sylpheed-0.7.7-r1.ebuild,v 1.2 2002/07/11 06:30:47 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A lightweight email client and newsreader"
SRC_URI="http://sylpheed.good-day.net/sylpheed/sylpheed-${PV}.tar.bz2"
HOMEPAGE="http://sylpheed.good-day.net"

DEPEND="=x11-libs/gtk+-1.2*
	>=media-libs/compface-1.4
	ssl? ( dev-libs/openssl )
	pda? ( app-misc/jpilot )
	crypt? ( >=app-crypt/gnupg-1.0.6 >=app-crypt/gpgme-0.2.3 )
	ldap? ( >=net-nds/openldap-2.0.11 )
	gnome? ( >=media-libs/gdk-pixbuf-0.11.0-r1 )"


RDEPEND="=x11-libs/gtk+-1.2*
	nls? ( sys-devel/gettext )
	ssl? ( dev-libs/openssl )
	crypt? ( >=app-crypt/gnupg-1.0.6 >=app-crypt/gpgme-0.2.3 )
	ldap? ( >=net-nds/openldap-2.0.11 )
	gnome? ( >=media-libs/gdk-pixbuf-0.11.0-r1 )"

src_compile() {

	local myconf

	use gnome || myconf="--disable-gdk-pixbuf --disable-imlib"
	use nls || myconf="$myconf --disable-nls"
	use ssl && myconf="$myconf --enable-ssl"
	use crypt && myconf="$myconf --enable-gpgme"
	use pda && myconf="$myconf --enable-jpilot"
	use ldap && myconf="$myconf --enable-ldap"
	
	./configure \
		--prefix=/usr \
		--host=${CHOST}  \
		--enable-ipv6 $myconf || die
	emake || die
}

src_install () {

	make prefix=${D}/usr \
		manualdir=${D}/usr/share/doc/${PF}/html \
		install || die
	dodoc AUTHORS COPYING ChangeLog* NEWS README* TODO*
}

