# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Authour: Mikael Hallendal <hallski@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gtkhtml/gtkhtml-0.11.1.ebuild,v 1.3 2001/08/23 10:12:08 hallski Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="gtkhtml"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/unstable/sources/gtkhtml/${A}"
HOMEPAGE="http://www.gnome.org/"

DEPEND=">=gnome-base/gal-0.6
	>=gnome-base/control-center-1.2.4
        >=gnome-base/libghttp-1.0.9
        >=gnome-base/libunicode-0.4
        >=dev-util/xml-i18n-tools-0.8.4
        bonobo? ( >=gnome-base/bonobo-1.0.4 )"

RDEPEND=">=gnome-base/gal-0.5
	 >=gnome-base/control-center-1.2.4
         >=gnome-base/libghttp-1.0.9
         >=gnome-base/libunicode-0.4
         bonobo? ( >=gnome-base/bonobo-1.0.4 )"


src_compile() {

        local myconf

        if [ -z "`use nls`" ]
        then
                myconf="--disable-nls"
        fi

        if [ "`use bonobo`" ]
        then
            myconf="${myconf} --with-bonobo"
        else
            myconf="${myconf} --without-bonobo"
        fi

  	try  ./configure --host=${CHOST} --prefix=/opt/gnome \
		 --sysconfdir=/etc/opt/gnome ${myconf} --with-gconf

  	try pmake
}

src_install() {

	try make DESTDIR=${D} install
  	dodoc AUTHORS COPYING* ChangeLog README
  	dodoc NEWS TODO

}













