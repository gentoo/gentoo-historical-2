# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-im/ymessenger/ymessenger-1.0.6.1.ebuild,v 1.1 2005/01/25 19:36:29 rizzo Exp $

inherit kde-functions rpm

IUSE="kde gnome"

MY_P=${PN}-${PV%.*}-${PV#*.*.*.*}
S=${WORKDIR}
DESCRIPTION="Yahoo's instant messenger client"
HOMEPAGE="http://public.yahoo.com/~mmk/index.html"
SRC_URI="http://public.yahoo.com/~mmk/rh9.${MY_P}.i386.rpm"


DEPEND="media-libs/gdk-pixbuf
	dev-libs/openssl"

RDEPEND="virtual/x11"

SLOT="0"
LICENSE="yahoo"
KEYWORDS="-* ~x86"

src_install () {
	cd ${S}/opt/ymessenger/bin

	exeinto /opt/ymessenger/bin
	doexe ymessenger.bin ymessenger

	insinto /opt/ymessenger/bin
	doins yahoo_kde.xpm yahoo_gnome.png
	doins ymessenger.desktop

	if use gnome
	then
		insinto /usr/share/gnome/apps/Internet
		doins ymessenger.desktop
		insinto /opt/ymessenger/bin
		doins ymessenger.desktop
	fi

	if use kde
	then
		insinto /usr/share/applnk/Internet
		doins ymessenger.kdelnk

		insinto /opt/ymessenger/bin
		doins ymessenger.kdelnk
	fi

	into /opt/ymessenger
	dolib ${S}/opt/ymessenger/lib/libgtkhtml.so.0

	cd ${T}
	echo "#!/bin/sh" > ymessenger.gentoo
	echo "LD_LIBRARY_PATH=/opt/ymessenger/lib:$LD_LIBRARY_PATH" >> ymessenger.gentoo
	echo "export LD_LIBRARY_PATH" >> ymessenger.gentoo
	echo "exec /opt/ymessenger/bin/ymessenger.bin $@" >> ymessenger.gentoo
	exeinto /usr/bin
	newexe ymessenger.gentoo ymessenger
}

pkg_postinst() {
	einfo ""
	einfo "If you are upgrading from an older version of ymessenger,"
	einfo "please unmerge the previous version."
	einfo "-=AND=-"
	einfo "mv ~/.ymessenger/preferences ~/.ymessenger/preferences.old"
	einfo ""
}
