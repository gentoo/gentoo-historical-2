# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# Maintainer: Spider <spider@gentoo.org>, Author Bart Verwilst <verwilst@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-im/ickle/ickle-0.2.2.ebuild,v 1.4 2002/04/06 19:39:15 verwilst Exp $

S=${WORKDIR}/${P}
DESCRIPTION="ICQ 200x compatible ICQ client. limited featureset."
SRC_URI="http://prdownloads.sourceforge.net/ickle/${P}.tar.gz"
HOMEPAGE="http://ickle.sf.net"
SLOT="0"


DEPEND=">=x11-libs/gtk+-1.2.10
		>=x11-libs/gtkmm-1.2.5
		>=dev-libs/libsigc++-1.0.4
		>=sys-libs/lib-compat-1.0
		gnome? ( >= gnome-base/gnome-applets-1.4.0 
			 >= gnome-base/gnome-libs-1.4.1 )"

src_compile() {
	local myflags
	myflags=""
	if [ -z "`use gnome`" ]
	then
		myflags="--without-gnome"
	else
		myflags="--with-gnome"
	fi
	./configure ${myflags} \
		--host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--infodir=/usr/share/info \
		--localstatedir=/var/lib \
		--mandir=/usr/share/man || die "./configure failed"
	emake || die

}

src_install () {

	make DESTDIR=${D} install || die

}
