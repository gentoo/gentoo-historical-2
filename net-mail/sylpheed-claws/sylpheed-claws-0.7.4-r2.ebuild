# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Desktop Team <desktop@gentoo.org>
# Author: Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/sylpheed-claws/sylpheed-claws-0.7.4-r2.ebuild,v 1.1 2002/04/10 17:26:45 karltk Exp $

S=${WORKDIR}/sylpheed-${PV}claws
DESCRIPTION="Bleeding edge version of Sylpheed"
SRC_URI="http://prdownloads.sourceforge.net/sylpheed-claws/sylpheed-${PV}claws.tar.gz"
HOMEPAGE="http://sylpheed-claws.sf.net"

DEPEND=">=x11-libs/gtk+-1.2.6
	ssl? ( >=dev-libs/openssl-0.9.6b )
	ldap? ( >=net-nds/openldap-2.0.7 )
	gnome? ( >=media-libs/gdk-pixbuf-0.16 )
	spell? ( >=app-text/pspell-0.12.2 )
	xface? ( >=media-libs/compface-1.4 )
	jpilot? ( >=app-misc/jpilot-0.99 )
	imlib? ( >=media-libs/imlib-1.9.10 )
	gpg? ( >=app-crypt/gpgme-0.2.3 )
	nls? ( sys-devel/gettext )
	"
	
RDEPEND="$DEPEND"

src_compile() {
	local myconf

	use ssl && myconf="${myconf} --enable-ssl"

	use gpg && myconf="${myconf} --enable-gpgme"

	use gnome && \
		myconf="${myconf} --enable-gdk-pixbuf" || \
		myconf="${myconf} --disable-gdk-pixbuf"

	use imlib && \
		myconf="${myconf} --enable-imlib" || \
		myconf="${myconf} --disable-imlib"
	
	use ldap && myconf="${myconf} --enable-ldap"
	
	use spell && myconf="${myconf} --enable-pspell"
	
	use ipv6 && myconf="${myconf} --enable-ipv6"

	use jpilot && myconf="${myconf} --enable-jpilot"

	use nls || myconf="${myconf} --disable-nls"

	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--program-suffix=-claws \
		${myconf} || die "./configure failed"

	for i in `find . -name Makefile` ; do
		cp $i ${i}.orig
		sed "s/PACKAGE = sylpheed/PACKAGE = sylpheed-claws/" \
			< ${i}.orig \
			> ${i}
	done
	cp sylpheed.desktop sylpheed.desktop.orig
	sed "s/sylpheed.png/sylpheed-claws.png/" \
		< sylpheed.desktop.orig
		> sylpheed.desktop

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	
	use gnome || rm -rf ${D}/usr/share/gnome

	mv ${D}/usr/share/pixmaps/sylpheed.png \
		${D}/usr/share/pixmaps/sylpheed-claws.png
}
