# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-libs/glibwww/glibwww-0.2-r1.ebuild,v 1.5 2001/08/23 10:20:31 hallski Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="The Gnome WWW Libraries"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/unstable/sources/${PN}/${A}"
HOMEPAGE="http://www.gnome.org/"

DEPEND=">=gnome-base/gnome-libs-1.2.13
	>=net-libs/libwww-1.5.3-r1
	gnome-base/gnome-env"

RDEPEND=">=net-libs/libwww-1.5.3-r1
	gnome-base/gnome-env"

src_compile() {
  try ./configure --host=${CHOST} --prefix=/opt/gnome
  try pmake
}

src_install() {
  try make prefix=${D}/opt/gnome install
  dodoc AUTHORS ChangeLog NEWS README
}





