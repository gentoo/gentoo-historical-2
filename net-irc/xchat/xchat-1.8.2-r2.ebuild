# Copyrigth 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>, Donny Davies <woodchip@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-irc/xchat/xchat-1.8.2-r2.ebuild,v 1.3 2001/10/07 11:11:08 azarah Exp $

S=${WORKDIR}/${P}
DESCRIPTION="xchat irc client"
SRC_URI="http://www.xchat.org/files/source/1.8/${P}.tar.bz2"
HOMEPAGE="http://www.xchat.org/"

DEPEND=">=x11-libs/gtk+-1.2.10-r4
        perl? ( sys-devel/perl )
        python? ( >=dev-lang/python-2.0-r4 )
        nls? ( >=sys-devel/gettext-0.10.38 )
        gnome? ( >=gnome-base/gnome-core-1.4.0.4-r1 >=media-libs/gdk-pixbuf-0.11.0-r1 )
        ssl? ( >=dev-libs/openssl-0.9.6a )"

RDEPEND=">=x11-libs/gtk+-1.2.10-r4
         gnome? ( >=gnome-base/gnome-core-1.4.0.4-r1 >=media-libs/gdk-pixbuf-0.11.0-r1 )
         ssl? ( >=dev-libs/openssl-0.9.6a )"


src_unpack() {
  unpack ${A}
}

src_compile() {
  local myopts myflags

  use gnome  && myopts="--enable-gnome --enable-panel"
  use gnome  || myopts="--enable-gtkfe --disable-gnome --disable-gdk-pixbuf --disable-zvt"
  use ssl    && myopts="$myopts --enable-openssl"
  use perl   && myopts="$myopts --disable-perl"
  use python && myflags="`python-config --libs` -lm"
  use python || myopts="$myopts --disable-python"
  use nls    || myopts="$myopts --disable-nls"

  CFLAGS="$CFLAGS -I/usr/include/orbit-1.0"

  ./configure --prefix=/usr --host=${CHOST} ${myopts} --enable-ipv6 || die

  if [ "$myflags" ] ; then
    for i in src/fe-gtk src/fe-text
    do
      if [ -e $i/Makefile ] ; then
        cp  $i/Makefile $i/Makefile.orig
        sed -e "s:-lpython2.0:$myflags:" \
	  $i/Makefile.orig > $i/Makefile
      fi
    done
  fi

  emake || die
}

src_install() {
  make prefix=${D}/usr install || die
  dodoc AUTHORS COPYING ChangeLog README
}
