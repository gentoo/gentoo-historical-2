# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Desktop Team <desktop@gentoo.org>
# Author: Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-mail/sylpheed-claws/sylpheed-claws-0.7.8.ebuild,v 1.1 2002/06/17 05:25:33 seemant Exp $


MY_P="sylpheed-${PV}claws"
S=${WORKDIR}/${MY_P}
DESCRIPTION="Bleeding edge version of Sylpheed"
SRC_URI="http://telia.dl.sourceforge.net/sourceforge/sylpheed-claws/${MY_P}.tar.bz2"
HOMEPAGE="http://sylpheed-claws.sf.net"

DEPEND="=x11-libs/gtk+-1.2*
	ssl? ( >=dev-libs/openssl-0.9.6b )
	ldap? ( >=net-nds/openldap-2.0.7 )
	crypt? ( >=app-crypt/gpgme-0.2.3 )
	gnome? ( >=media-libs/gdk-pixbuf-0.16 )
	imlib? ( >=media-libs/imlib-1.9.10 )
	spell? ( >=app-text/pspell-0.12.2 )
	xface? ( >=media-libs/compface-1.4 )
	pda? ( >=app-misc/jpilot-0.99 )"
	
RDEPEND="$DEPEND
	nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	use ssl && myconf="${myconf} --enable-ssl"

	use crypt && myconf="${myconf} --enable-gpgme"

	use gnome && \
		myconf="${myconf} --enable-gdk-pixbuf" || \
		myconf="${myconf} --disable-gdk-pixbuf"

	use imlib && \
		myconf="${myconf} --enable-imlib" || \
		myconf="${myconf} --disable-imlib"
	
	use ldap && myconf="${myconf} --enable-ldap"
	
	use spell && myconf="${myconf} --enable-pspell"
	
	use ipv6 && myconf="${myconf} --enable-ipv6"

	use pda && myconf="${myconf} --enable-jpilot"

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
