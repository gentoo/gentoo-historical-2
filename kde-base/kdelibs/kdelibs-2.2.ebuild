# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# /home/cvsroot/gentoo-x86/kde-base/kdelibs/kdelibs-2.1.2.ebuild,v 1.3 2001/06/07 01:45:52 achim Exp

V=${PV}
A=${PN}-${V}.tar.bz2
S=${WORKDIR}/${PN}-${V}
DESCRIPTION="KDE ${PV} - libs"
SRC_PATH="kde/stable/${V}/src/${A}"
SRC_URI="ftp://ftp.kde.org/pub/$SRC_PATH
	 ftp://ftp.fh-heilbronn.de/pub/mirrors/$SRC_PATH
	 ftp://ftp.sourceforge.net/pub/mirrors/$SRC_PATH"

HOMEPAGE="http://www.kde.org/"

DEPEND=">=sys-devel/gcc-2.95.2  sys-devel/perl
	>=media-libs/audiofile-0.1.9
	>=x11-libs/qt-x11-2.3.0
        >=sys-apps/bzip2-1.0.1
	>=dev-libs/libpcre-3.4
	>=gnome-libs/libxml2-2.4.1
	ssl? ( >=dev-libs/openssl-0.9.6 )
	alsa? ( >=media-libs/alsa-lib-0.5.9 )
	cups? ( net-print/cups )
	sys-devel/autoconf"

RDEPEND=">=sys-devel/gcc-2.95.2
	 >=media-libs/audiofile-0.1.9
         >=media-libs/tiff-3.5.5
         >=sys-apps/bzip2-1.0.1
	 >=dev-libs/libpcre-3.4
	 >=x11-libs/qt-x11-2.3.0
         ~kde-base/kde-env-2.2
         app-text/sgml-commonk
         alsa? ( >=media-libs/alsa-lib-0.5.9 )
	cups? ( net-print/cups )
         ssl? ( >=dev-libs/openssl-0.9.6 )
	sys-devel/perl dev-lang/python"

src_unpack() {
    unpack ${A}
    cd ${S}
#    patch -p0 < ${FILESDIR}/${PN}-2.1.1-ksgmltools-gentoo.diff
#    rm configure
#    autoconf
}

src_compile() {

    QTBASE=/usr/X11R6/lib/qt

    local myopts
    if [ "`use ssl`" ] ; then
      myopts="--with-ssl-dir=/usr"
    else
      myopts="--without-ssl"
    fi
    if [ "`use alsa`" ] ; then
      myopts="$myopts --with-alsa"
    fi
    if [ -z "`use cups`" ] ; then
      myopts="$myopts --disable-cups"
    fi
    if [ "`use qtmt`" ] ; then
      myopts="$myopts --enable-mt"
    fi
    if [ "`use mitshm`" ] ; then
      myopts="$myopts --enable-mitshm"
    fi
    if [ -z "`use ipv6`" ] ; then
      myopts="$myopts --with-ipv6-lookup=no"
    fi
    try ./configure --prefix=/opt/kde${V} --host=${CHOST} \
		--with-qt-dir=$QTBASE $myopts --with-xinerama \
		--disable-libfam
    cd ${S}
    try make
}

src_install() {
  try make install DESTDIR=${D}
  dodoc AUTHORS ChangeLog COMPILING COPYING* NAMING NEWS README
  docinto html
  dodoc *.html
}


pkg_postinst() {
     if [ -x  "/usr/bin/install-catalog" ] && [ "$ROOT" = "/" ] ; then
 #     install-catalog --add /etc/sgml/kde-docbook.cat /usr/share/sgml/docbook/kde-customizations/catalog
 #     install-catalog --add /etc/sgml/kde-docbook.cat /etc/sgml/sgml-docbook.cat
	echo
    fi
}

pkg_prerm() {
    if [ -x  "/usr/bin/install-catalog" ] && [ "$ROOT" = "/" ] ; then
      if [ -e "/etc/sgml/kde-docbook.cat" ] ; then
#        install-catalog --remove /etc/sgml/kde-docbook.cat /usr/share/sgml/docbook/kde-customizations/catalog
#        install-catalog --remove /etc/sgml/kde-docbook.cat /etc/sgml/sgml-docbook.cat
	echo
      fi
    fi
}
