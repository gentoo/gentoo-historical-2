# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-video/xawtv/xawtv-3.60.ebuild,v 1.1 2001/08/25 21:26:32 achim Exp $

A=xawtv_${PV}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="TV application for the bttv driver"
SRC_URI="http://www.strusel007.de/linux/xawtv/${A}"
HOMEPAGE="http://www.strusel007.de/linux/xawtv/"

DEPEND="virtual/glibc
	>=sys-libs/ncurses-5.1
	>=media-libs/jpeg-6b
        >=media-libs/libpng-1.0.8
	>=x11-base/xfree-4.0.1
	motif? ( x11-libs/openmotif )
	aalib? ( media-libs/aalib )
	quicktime? ( media-libs/quicktime4linux )"

src_compile() {

  unset DEPEND
  if [ "`use motif`" ] ; then
    myconf="--enable-motif"
  else
    myconf="--disable-motif"
  fi
  if [ "`use aalib`" ] ; then
    myconf="$myconf --enable-aa"
  else
    myconf="$myconf --disable-aa"
  fi
  if [ "`use quicktime`" ] ; then
    myconf="$myconf --enable-quicktime"
  else
    myconf="$myconf --disable-quicktime"
  fi
  touch src/Xawtv.h src/MoTV.h
  try ./configure --host=${CHOST} --prefix=/usr --disable-lirc \
	--enable-jpeg --enable-xfree-ext --enable-xvideo --with-x ${myconf}
  try make
}

src_install() {

  try make prefix=${D}/usr mandir=${D}/usr/share/man \
	resdir=${D}/etc/X11/app-defaults install

  dodoc COPYING Changes KNOWN_PROBLEMS Miro_gpio.txt Programming-FAQ
  dodoc README* Sound-FAQ TODO Trouble-Shooting UPDATE_TO_v3.0
  insinto /usr/local/httpd/cgi-bin
  insopts -m 755
  doins webcam/webcam.cgi

}






