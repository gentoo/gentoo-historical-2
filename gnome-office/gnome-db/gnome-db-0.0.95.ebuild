# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-office/gnome-db/gnome-db-0.0.95.ebuild,v 1.3 2000/09/15 20:08:57 drobbins Exp $

P=gnome-db-0.0.95
A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="Framework for creating database applications"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/gnome-db/"${A}
HOMEPAGE="http://www.gnome.org/gnome_db/"


src_compile() {                           
  cd ${S}

  try ./configure --host=${CHOST} --prefix=/opt/gnome \
	--with-mysql=/usr --with-ldap=/usr --with-catgets
  try make
}

src_install() {                               
  cd ${S}
  try make prefix=${D}/opt/gnome install
}



