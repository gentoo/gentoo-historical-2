# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-mail/sylpheed/sylpheed-0.8.8.ebuild,v 1.1 2002/12/26 17:20:57 bcowan Exp $

IUSE="ssl xface ipv6 nls gnome ldap crypt pda"

S=${WORKDIR}/${P}

DESCRIPTION="A lightweight email client and newsreader"
SRC_URI="http://sylpheed.good-day.net/${PN}/${P}.tar.bz2"
HOMEPAGE="http://sylpheed.good-day.net"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86"

PROVIDE="virtual/sylpheed"

DEPEND="=x11-libs/gtk+-1.2*
	xface? ( >=media-libs/compface-1.4 )
	ssl? ( dev-libs/openssl )
	pda? ( app-misc/jpilot )
	crypt? ( >=app-crypt/gnupg-1.0.6 >=app-crypt/gpgme-0.2.3 )
	ldap? ( >=net-nds/openldap-2.0.11 )
	gnome? ( >=media-libs/gdk-pixbuf-0.11.0-r1 )"

src_compile() {

	local myconf

	use gnome || myconf="${myconf} --disable-gdk-pixbuf --disable-imlib"
	
	use nls || myconf="${myconf} --disable-nls"
	
	use ssl && myconf="${myconf} --enable-ssl"
	
	use crypt && myconf="${myconf} --enable-gpgme"
	
	use pda && myconf="${myconf} --enable-jpilot"
	
	use ldap && myconf="${myconf} --enable-ldap"
	
	use ipv6 && myconf="${myconf} --enable-ipv6"
	
	use xface || myconf="${myconf} --disable-compface"
	
	econf ${myconf} 

	emake || die
}

src_install () {

	einstall 	

	dodir /usr/share/pixmaps 
	insinto /usr/share/pixmaps
	doins *.png
	
	if use gnome
	    then
		dodir /usr/share/gnome/apps/Internet
		insinto /usr/share/gnome/apps/Internet
		doins sylpheed.desktop
	fi
	
	dodoc ABOUT-NLS AUTHORS COPYING ChangeLog* NEWS README* TODO*
}

