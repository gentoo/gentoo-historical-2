# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# /home/cvsroot/gentoo-x86/media-sound/esound/esound-0.2.22-r2.ebuild,v 1.2 2001/06/11 08:11:28 hallski Exp

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="esound"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/esound/${A}
           ftp://download.sourceforge.net/pub/mirrors/gnome/stable/sources/esound/${A}"
HOMEPAGE="http://www.tux.org/~ricdude/EsounD.html"

DEPEND="virtual/glibc
	alsa? ( >=media-libs/alsa-lib-0.5.9 )
	>=media-libs/audiofile-0.1.9
    tcpd? ( >=sys-apps/tcp-wrappers-7.6-r2 )"

RDEPEND="virtual/glibc
	alsa? ( >=media-libs/alsa-lib-0.5.9 )
	>=media-libs/audiofile-0.1.9"

src_unpack() {

  unpack ${A}

  cd ${S}
  
  patch -p0 <${FILESDIR}/esddsp.c.diff || die

}

src_compile() {                           

  local myconf
  if [ "`use tcpd`" ]
  then
    myconf="--with-libwrap"
  else
    myconf="--without-libwrap"
  fi

# ALSA support broken ... need newer ALSA ?
#  if [ "`use alsa`" ]
#  then
#    myconf="$myconf --enable-alsa"
#  else
    myconf="$myconf --enable-alsa=no"
#  fi

  ./configure --host=${CHOST} --prefix=/usr \
		  --sysconfdir=/etc/esd $myconf || die
  pmake || die
}

src_install() {                               
  cd ${S}
  make prefix=${D}/usr sysconfdir=${D}/etc/esd install || die
  dodoc AUTHORS COPYING* ChangeLog README TODO
  dodoc NEWS TIPS
  dodoc docs/esound.ps
  docinto html
  dodoc docs/html/*.html docs/html/*.css
  docinto html/stylesheet-images
  dodoc docs/html/stylesheet-images/*.gif
}






