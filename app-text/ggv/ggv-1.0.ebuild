# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# /home/cvsroot/gentoo-x86/gnome-apps/ggv/ggv-0.95-r1.ebuild,v 1.2 2001/02/01 19:30:33 achim Exp

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Gnome Ghostview"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/"${A}
HOMEPAGE="http://www.gnome.org/"

DEPEND=">=app-text/ghostscript-6.23
	>=gnome-base/gnome-libs-1.2.4
        bonobo? ( >=gnome-base/bonobo-1.0 )
        nls? ( sys-devel/gettext )"

src_compile() {
  local myconf
  if [ -z "`use nls`" ] ; then
     myconf="--disable-nls"
  fi
  if [ "`use bonobo`" ] ; then
    myconf="$myconf --with-bonobo"
  else
    myconf="$myconf --without-bonobo"
    cp configure configure.orig
    sed -e "s/BONOBO_TRUE/BONOBO_FALSE/" configure.orig > configure
  fi
  try ./configure --host=${CHOST} --prefix=/opt/gnome \
	$myconf
  # bonobo support does not work yet
  try make
}

src_install() {
  try make prefix=${D}/opt/gnome install
  dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}




