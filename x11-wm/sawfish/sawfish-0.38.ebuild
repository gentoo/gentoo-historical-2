# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-wm/sawfish/sawfish-0.38.ebuild,v 1.2 2001/06/06 16:55:51 achim Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Extensible window manager using a Lisp-based scripting language"
SRC_URI="ftp://sawmill.sourceforge.net/pub/sawmill/"${A}
HOMEPAGE="http://sawmill.sourceforge.net/"
DEPEND=">=dev-libs/rep-gtk-0.15-r1
        >=dev-libs/librep-0.13.6
	esd? ( >=media-sound/esound-0.2.22 )
        readline? ( >=sys-libs/readline-4.1 )
        nls? ( sys-devel/gettext )
	gnome? ( >=gnome-base/gnome-core-1.4.0 )"
DEPEND=">=dev-libs/rep-gtk-0.15-r1
        >=dev-libs/librep-0.13.6
        >=x11-libs/gtk+-1.2.10
	esd? ( >=media-sound/esound-0.2.22 )
	gnome? ( >=gnome-base/gnome-core-1.4.0 )"

src_compile() {

  	local myconf
        if [ "`use esd`" ]
        then
          myconf="--with-esd"
        else
          myconf="--without-esd"
        fi
        if [ "`use gnome`" ]
        then
          myconf="${myconf} --with-gnome-prefix=/opt/gnome --enable-gnome-widgets --enable-capplet"
        else
          myconf="${myconf} --disable-gnome-widgets --disable-capplet"
        fi
        if [ "`use readline`" ]
        then
          myconf="${myconf} --with-readline"
        else
          myconf="${myconf} --without-readline"
        fi
        if [ -z "`use nls`" ]
        then
          myconf="${myconf} --disable-linguas"
        fi

 	try ./configure --host=${CHOST} --prefix=/usr/X11R6 --infodir=/usr/X11R6/info --libexecdir=/usr/X11R6/lib --with-audiofile ${myconf}

	#pmake doesn't work, stick with make
	try make
}

src_install() {

  try make DESTDIR=${D} install
  dodoc AUTHORS BUGS COPYING ChangeLog DOC FAQ NEWS README THANKS TODO

}



