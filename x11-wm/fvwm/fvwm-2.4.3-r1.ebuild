# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Prakash Shetty <crux@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-wm/fvwm/fvwm-2.4.3-r1.ebuild,v 1.1 2002/02/14 22:07:18 danarmak Exp $


S=${WORKDIR}/${P}
DESCRIPTION="an extremely powerful ICCCM-compliant multiple virtual desktop window manager"
SRC_URI="ftp://ftp.fvwm.org/pub/fvwm/version-2/${P}.tar.bz2"
HOMEPAGE="http://www.fvwm.org/"

DEPEND="virtual/glibc
	>=sys-libs/readline-4.1
	>=x11-libs/gtk+-1.2.10-r4
	>=dev-libs/libstroke-0.4
	gnome? ( >=gnome-base/gnome-libs-1.4.1.2-r1 )"


src_compile() {
	local myconf
	if [ -n "$( use gnome )" ]; then
		myconf="--with-gnome"
	else
		myconf="--without-gnome"
	fi

	./configure --prefix=/usr --host=${CHOST} \
		--libexecdir=/usr/lib \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info ${myconf}

	emake || die
}

src_install () {
	make DESTDIR=${D} install || die
	
	exeinto /etc/X11/Sessions
	doexe $FILESDIR/fvwm2
}
