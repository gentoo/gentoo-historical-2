# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/nut/nut-0.44.1.ebuild,v 1.3 2000/11/02 08:31:53 achim Exp $

P=nut-0.44.1
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Network-UPS Tools"
SRC_URI="http://www.exploits.org/nut/release/"${A}
HOMEPAGE="http://www.exploits.org/nut/"

DEPEND=">=sys-libs/glibc-2.1.3
	>=media-libs/libgd-1.8.3
	>=media-libs/freetype-1.3.1
	>=media-libs/libpng-1.0.7"

src_unpack() {
  unpack ${A}
}

src_compile() {                           
  cd ${S}
  try ./configure --host=${CHOST} --prefix=/usr --sysconfdir=/etc/nut \
	--with-user=daemon --with-group=daemon
  try make
  try make cgi
}

src_install() {                               
  cd ${S}
  try make BASEPATH=${D}/usr CONFPATH=${D}/etc/nut STATEPATH=${D}/var/state/ups \
	install
  cd clients
  exeinto /usr/local/httpd/cgi-bin/nut
  doexe *.cgi
  into /usr
  dolib upsfetch.o
  insinto /usr/include
  doins upsfetch.h
  cd ..
  rmdir ${D}/usr/misc
  insinto /etc/rc.d/init.d
  doins ${O}/files/upsd
  dodoc COPYING CREDITS Changes QUICKSTART README
  docinto docs
  dodoc docs/*.txt docs/FAQ docs/Changes.trust
  docinto cables
  dodoc docs/cables/*.txt
}


pkg_config() {

   . ${ROOT}/etc/rc.d/config/functions

  einfo "Generating symlinks..."
  ${ROOT}/usr/sbin/rc-update add upsd

}


