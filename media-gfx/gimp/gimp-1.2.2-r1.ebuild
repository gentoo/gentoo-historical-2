# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gimp/gimp-1.2.2-r1.ebuild,v 1.1 2001/10/06 10:38:04 azarah Exp $

A=${P}.tar.bz2
S=${WORKDIR}/${P}
DESCRIPTION="GIMP"
SRC_URI="ftp://ftp.insync.net/pub/mirrors/ftp.gimp.org/gimp/v1.2/v${PV}/"${A}
HOMEPAGE="http://www.gimp.org"

DEPEND="nls? ( sys-devel/gettext )
        sys-devel/autoconf sys-devel/automake
	>=x11-libs/gtk+-1.2.10-r4
	>=media-libs/mpeg-lib-1.3.1
	aalib? ( >=media-libs/aalib-1.2 )
	perl? ( >=dev-perl/PDL-2.2.1
        	>=dev-perl/Parse-RecDescent-1.80 
		>=dev-perl/gtk-perl-0.7004 )
	gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1 )"

RDEPEND=">=x11-libs/gtk+-1.2.10-r4
	 aalib? ( >=media-libs/aalib-1.2 )
         perl? ( >=dev-perl/PDL-2.2.1
	         >=dev-perl/Parse-RecDescent-1.80 
		 >=dev-perl/gtk-perl-0.7004 )
	 gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1 )"

src_unpack() {
  unpack ${A}
  cd ${S}/plug-ins/common

  # compile with nonstandard psd_save plugin
  cp ${FILESDIR}/psd_save.c .
  patch -p0 < ${FILESDIR}/${PF}-gentoo.diff

  cd ${S}
  automake
  autoconf
}

src_compile() {                           
  local myconf
  local mymake
  if [ -z "`use nls`" ] ; then
    myconf="--disable-nls"
  fi

  if [ -z "`use perl`" ] ; then
    myconf="$myconf --disable-perl"
  fi

  if [ -z "`use aalib`" ] ; then
    mymake="LIBAA= AA="
  fi

  if [ -z "`use gnome`" ] ; then
    mymake="$mymake HELPBROWSER="
  fi

  try ./configure --host=${CHOST} --prefix=/usr --sysconfdir=/etc --with-mp ${myconf}

  try make $mymake  # Doesn't work with -j 4 (hallski)
}

src_install() {
  local mymake                               
  if [ -z "`use aalib`" ] ; then
    mymake="LIBAA= AA="
  fi

  if [ -z "`use gnome`" ] ; then
    mymake="$mymake HELPBROWSER="
  fi
  dodir /usr/lib/gimp/1.2/plug-ins
  try make prefix=${D}/usr gimpsysconfdir=${D}/etc/gimp/1.2 \
	mandir=${D}/usr/share/man PREFIX=${D}/usr $mymake install
  preplib /usr
  dodoc AUTHORS COPYING ChangeLog* *MAINTAINERS README* TODO
  dodoc docs/*.txt docs/*.ps docs/Wilber* docs/quick_reference.tar.gz
  docinto html/libgimp
  dodoc devel-docs/libgimp/html/*.html
  docinto devel
  dodoc devel-docs/*.txt
}





