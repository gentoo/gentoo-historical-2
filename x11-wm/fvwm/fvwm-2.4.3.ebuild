# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Prakash Shetty <crux@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/x11-wm/fvwm/fvwm-2.4.3.ebuild,v 1.4 2002/05/23 06:50:20 seemant Exp $


S=${WORKDIR}/${P}
DESCRIPTION="an extremely powerful ICCCM-compliant multiple virtual desktop window manager"
SRC_URI="ftp://ftp.fvwm.org/pub/fvwm/version-2/${P}.tar.bz2"
HOMEPAGE="http://www.fvwm.org/"

DEPEND="virtual/glibc
	>=sys-libs/readline-4.1
	=x11-libs/gtk+-1.2*
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
}
