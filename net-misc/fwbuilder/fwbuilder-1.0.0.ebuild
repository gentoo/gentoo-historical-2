# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/fwbuilder/fwbuilder-1.0.0.ebuild,v 1.8 2002/10/04 06:11:26 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="A firewall GUI"
SRC_URI="mirror://sourceforge/fwbuilder/${P}.tar.gz"
HOMEPAGE="http://fwbuilder.sourceforge.net"
LICENSE="GPL-2"
KEYWORDS="x86 sparc sparc64"
SLOT="0"

DEPEND=">=x11-libs/gtkmm-1.2.5-r1
	>=dev-libs/libxslt-1.0.1
	>=net-libs/libfwbuilder-0.10.0
	media-libs/gdk-pixbuf
	dev-libs/libxml2"

src_compile() {
    local myconf
	
	use static && myconf="${myconf} --enable-shared=no --enable-static=yes"

    ./configure	\
		--prefix=/usr	\
		--host=${CHOST}	\
		|| die

    cp config.h config.h.orig
    sed -e "s:#define HAVE_XMLSAVEFORMATFILE 1://:" config.h.orig > config.h
	
	if [ "`use static`" ]
	then
		make LDFLAGS="-static" || die
	else
		make || die
	fi
}

src_install () {

    make	\
		DESTDIR=${D} \
		install || die

}
