# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/media-libs/libsdl/libsdl-1.1.8-r1.ebuild,v 1.1 2001/02/21 06:25:14 achim Exp $

A=SDL-${PV}.tar.gz
S=${WORKDIR}/SDL-${PV}
DESCRIPTION="Simple Direct Media Layer"
SRC_URI="http://www.libsdl.org/release/"${A}
HOMEPAGE="http://www.libsdl.org/"

DEPEND="virtual/glibc
    >=dev-lang/nasm-0.98
    >=media-libs/audiofile-0.1.9
    >=media-libs/alsa-lib-0.5.9
    opengl? ( >=media-libs/mesa-3.4 )
    svga? ( >=media-libs/svgalib-1.4.2 )
    esd? ( >=media-sound/esound-0.2.19 )
    X? ( >=x11-base/xfree-4.0.1 )
    arts? ( >=kde-base/kdelibs-2.0.1 )
    nas? ( media-sound/nas )"

src_compile() {

  local myconf

  if [ -z "`use esd`" ]
  then
    myconf="--disable-esd"
  fi

  if [ -z "`use arts`" ]
  then
    myconf="${myconf} --disable-arts"
  fi

  if [ -z "`use nas`" ]
  then
    myconf="${myconf} --disable-nas"
  fi

  if [ -z "`use X`" ]
  then
    myconf="${myconf} --disable-video-x11"
  fi
  if [ "`use svga`" ]
  then
    myconf="${myconf} --enable-video-svga"
  fi
  if [ -z "`use fbcon`" ]
  then
    myconf="${myconf} --disable-video-fbcon"
  fi
  if [ "`use aalib`" ]
  then
    myconf="${myconf} --enable-video-aalib"
  fi
  if [ "`use ggi`" ]
  then
    myconf="${myconf} --enable-video-ggi"
  fi
  if [ -z "`use opengl`" ]
  then
    myconf="${myconf} --disable-video-opengl"
  fi

  try ./configure --host=${CHOST} --prefix=/usr --mandir=/usr/share/man ${myconf}

  try make

}

src_install() {
  cd ${S}
  try make DESTDIR=${D} install
  preplib /usr
  dodoc BUGS COPYING CREDITS README* TODO WhatsNew
  docinto html
  dodoc *.html
  docinto html/docs
  dodoc docs/*.html
  
}
pkg_postinst() {

 ldconfig -r ${ROOT}

}



