# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-libs/ammonite/ammonite-1.0.2.ebuild,v 1.5 2001/06/11 08:11:28 hallski Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="ammonite"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${A}
         ftp://gnome.eazel.com/pub/gnome/stable/sources/${PN}/${A}"

HOMEPAGE="http://www.gnome.org/"

DEPEND="nls? ( sys-devel/gettext )
        >=gnome-base/gnome-libs-1.2.12
        >=gnome-base/gconf-0.50
        >=dev-libs/openssl-0.9.6
        >=dev-util/xml-i18n-tools-0.8.4"

RDEPEND=">=gnome-base/gnome-libs-1.2.12
        >=gnome-base/gconf-0.50
        >=dev-libs/openssl-0.9.6"

src_unpack() {
  unpack ${A}
  cd ${S}
  patch -p1 < ${FILESDIR}/${PN}-1.0.0-gentoo.diff
}

src_compile() {
  local myconf
  if [ -z "`use nls`" ]
  then
    myconf="--disable-nls"
  fi
  try ./configure --host=${CHOST} --prefix=/opt/gnome  --sysconfdir=/etc/opt/gnome ${myconf}
  try pmake
}

src_install() {
  try make prefix=${D}/opt/gnome sysconfdir=${D}/etc/opt/gnome install
  dodoc ABOUT-NLS AUTHORS COPYING* HACKING README NEWS
  dodoc TODO doc/*.txt

}




