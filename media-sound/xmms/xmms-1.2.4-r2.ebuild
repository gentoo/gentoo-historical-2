# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-sound/xmms/xmms-1.2.4-r2.ebuild,v 1.1 2001/04/21 06:57:47 achim Exp $

S=${WORKDIR}/${P}
DESCRIPTION="X MultiMedia System"
SRC_URI="ftp://ftp.xmms.org/xmms/1.2.x/${P}.tar.gz"
HOMEPAGE="http://www.xmms.org/"

DEPEND="gnome? ( >=gnome-base/gnome-core-1.2.2.1 )
	>=gnome-base/libxml-1.8.10
	>=media-libs/libmikmod-3.1.9
	>=media-libs/mesa-glu-3.4
    >=media-sound/esound-0.2.22
	>=x11-libs/gtk+-1.2.8"

RDEPEND="gnome? ( >=gnome-base/gnome-core-1.2.2.1 )
	 >=gnome-base/libxml-1.8.10
  	 >=media-libs/libmikmod-3.1.9
     >=media-sound/esound-0.2.22
	 >=x11-libs/gtk+-1.2.8"

src_unpack() {
  unpack ${A}
}

src_compile() {                           
  cd ${S}
  local myopts
  if [ -n "`use gnome`" ]
  then
	myopts="--prefix=/opt/gnome --with-gnome"
  else
	myopts="--prefix=/usr/X11R6 --without-gnome"
  fi
  CFLAGS="$CFLAGS -I/opt/gnome/include" try ./configure --host=${CHOST} ${myopts}
  try make

}

src_install() {                               
  cd ${S}
  if [ -n "`use gnome`" ]
  then
    try make prefix=${D}/opt/gnome \
	gnorbadir=${D}/opt/gnome/etc/CORBA/servers \
	sysdir=${D}/opt/gnome/share/applets/Multimedia \
	install
  else
    try make prefix=${D}/usr/X11R6 install
  fi
  dodoc AUTHORS ChangeLog COPYING FAQ NEWS README TODO 
  insinto /usr/X11R6/include/X11/pixmaps/
  donewins gnomexmms/gnomexmms.xpm xmms.xpm
}





