# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/gtkDPS/gtkDPS-0.3.4.ebuild,v 1.18 2005/04/14 20:36:13 lu_zero Exp $

inherit gnuconfig

IUSE="nls"

DESCRIPTION="Set of functions, objects and widgets to use DPS easily with GTK"
SRC_URI="ftp://ftp.gyve.org/pub/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gyve.org/gtkDPS/"
LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="x86 sparc alpha ppc amd64 ia64"

DEPEND="virtual/libc
	=x11-libs/gtk+-1.2*
	virtual/x11
	nls? ( sys-devel/gettext )"

src_compile() {
	# needed for alpha and amd64 ... but run everywhere
	gnuconfig_update || die "gnuconfig_update failed"

	if ! use nls ; then
		myconf="--disable-nls"
	fi

	./configure --prefix=/usr --host=${CHOST} \
		--with-x --with-dps $myconf || die
	#Very ugly workaround 
	use nls && echo '#define LOCALEDIR "/usr/share/locale"' >> config.h
	make || die
}

src_install () {
	make prefix=${D}/usr install || die
	dodoc COPYING* ChangeLog GTKDPS-VERSION HACKING NEWS README TODO
}
