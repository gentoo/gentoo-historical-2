# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-media/gnome-media-1.2.2.ebuild,v 1.6 2001/08/31 03:23:39 pm Exp $


A=${P}.tar.bz2
S=${WORKDIR}/${P}
DESCRIPTION="gnome-media"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/gnome-media/"${A}
HOMEPAGE="http://www.gnome.org/"

DEPEND=">=gnome-base/gnome-libs-1.2.4
        >=gnome-base/scrollkeeper-0.2
        nls? ( sys-devel/gettext )"

RDEPEND=">=gnome-base/gnome-libs-1.2.4"

src_compile() {                           
  local myconf
  if [ -z "`use nls`" ] ; then
     myconf="--disable-nls"
  fi
  try ./configure --host=${CHOST} --prefix=/opt/gnome \
	--with-ncurses $myconf

  if [ -z "`use alsa`"  ] ; then
    cp config.h config.h.orig
    sed -e "s:#define ALSA 1:/* #define ALSA 0*/:" config.h.orig > config.h
  fi
  try pmake
}

src_install() {                               
  cd ${S}
  try make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING* ChangeLog NEWS
  dodoc README*
}




