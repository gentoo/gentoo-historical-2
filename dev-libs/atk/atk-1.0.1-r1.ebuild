# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Spider  <spider.gentoo@darkmere.wanfear.com>
# $Header: /var/cvsroot/gentoo-x86/dev-libs/atk/atk-1.0.1-r1.ebuild,v 1.3 2002/05/21 18:14:07 danarmak Exp $

# ACONFVER=2.52f
# AMAKEVER=1.5b
# inherit autotools 
SLOT="1"
S=${WORKDIR}/${P}
DESCRIPTION="Gnome Accessibility Toolkit"
SRC_URI="ftp://ftp.gtk.org/pub/gtk/v2.0/${P}.tar.bz2"
HOMEPAGE="http://developer.gnome.org/projects/gap/"

DEPEND=">=dev-util/pkgconfig-0.12.0
		>=dev-libs/glib-2.0.1
		doc? ( >=dev-util/gtk-doc-0.9-r2 )"

src_compile() {
	local myconf
	 use doc && myconf="${myconf} --enable-gtk-doc" || myconf="${myconf} --disable-gtk-doc"
	 
	./configure --host=${CHOST} \
		    --prefix=/usr \
			--sysconfdir=/etc \
		    --infodir=/usr/share/info \
		    --mandir=/usr/share/man \
			${myconf} \
		    --enable-debug || die
## Since glib fails with debug, we debug here too
	emake || die
}

src_install() {
	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		infodir=${D}/usr/share/info \
		mandir=${D}/usr/share/man \
		install || die
    
	dodoc AUTHORS ChangeLog COPYING README* INSTALL NEWS 
}





