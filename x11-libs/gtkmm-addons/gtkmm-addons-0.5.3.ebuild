# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Martin Schlemmer <azarah@gentoo.org>

MY_P="`echo ${P} |sed -e 's/-//' -e 's/g/G/' -e 's/a/A/'`"
S=${WORKDIR}/${MY_P}
DESCRIPTION="Gtk--Addons - a set of extensions to gtk[--]."
SRC_URI="http://home.wtal.de/petig/Gtk/${MY_P}.tar.gz"
HOMEPAGE="http://home.wtal.de/petig/Gtk/"

DEPEND=">=x11-libs/gtk+-1.2.10-r4
	>=x11-libs/gtkmm-1.2.5-r1"


src_compile() {
	./configure --host=${CHOST} 					\
		    --prefix=/usr					\
	assert

	emake || die
}

src_install () {
	make prefix=${D}/usr					\
	     install || die

	dodoc AUTHORS COPYING COPYING.LIB ChangeLog INSTALL NEWS README TODO
}
