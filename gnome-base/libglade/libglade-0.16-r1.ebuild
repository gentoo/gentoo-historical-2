# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libglade/libglade-0.16-r1.ebuild,v 1.5 2001/08/31 22:11:27 hallski Exp $

A=${P}.tar.gz
S=${WORKDIR}/${P}
DESCRIPTION="libglade"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${A}"
HOMEPAGE="http://www.gnome.org/"

RDEPEND=">=gnome-base/gnome-libs-1.2.12
	 >=gnome-base/libxml-1.8.11
	 bonobo? ( >=gnome-base/bonobo-1.0.0 )"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"

src_compile() {
	local myopts

	if [ "`use bonobo`" ]
	then
		myconf="--enable-bonobo --disable-bonobotest"
	else
		myconf="--disable-bonobo"
	fi

	if [ -z "`use nls`" ]
	then
		myconf="${myconf} --disable-nls"
	fi

	./configure --host=${CHOST} --prefix=/opt/gnome 		\
	            --disable-gnomedb --mandir=/opt/gnome/man ${myconf}
	assert

	emake || die
}

src_install() {
	make prefix=${D}/opt/gnome install || die
	
	dodoc AUTHORS COPYING* ChangeLog NEWS
	dodoc doc/*.txt
}
