# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# Updated by Sebastian Werner <sebastian@werner-productions.de>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/nautilus/nautilus-1.0.6-r5.ebuild,v 1.1 2002/03/21 07:13:57 azarah Exp $


S=${WORKDIR}/${P}
DESCRIPTION="nautilus"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"

HOMEPAGE="http://www.gnome.org/"

RDEPEND="mozilla? ( >=net-www/mozilla-0.9.5 )
	>=app-admin/fam-oss-2.6.4
	>=media-sound/cdparanoia-3.9.8
	>=gnome-base/bonobo-1.0.9-r1
	>=gnome-base/gnome-core-1.4.0.4-r1
	>=gnome-base/libghttp-1.0.9-r1
	>=gnome-base/gnome-vfs-1.0.3
	>=gnome-base/librsvg-1.0.1
	>=gnome-base/eel-1.0.2
	>=gnome-extra/medusa-0.5.1-r1"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	>=app-text/scrollkeeper-0.2
	>=dev-util/intltool-0.11"

src_unpack() {

	unpack ${P}.tar.gz

	# The following is a temporary patch contributed by Naresh Donti
	# to fix the 50 defunct copies of sh caused by hyperbola.  This patch
	# will no longer be needed with a future version of scrollkeeper.
	# see bug #566 for more information

	patch -p0 < ${FILESDIR}/nautilus-1.0.6-hyperbola.diff
}

src_compile() {                           
	local myconf
	
	if [ -z "`use nls`" ]
	then
		myconf="${myconf} --disable-nls"
		mkdir intl
		touch intl/libgettext.h
	fi

	if [ "`use mozilla`" ]
	then
		MOZILLA=${MOZILLA_FIVE_HOME}
		myconf="${myconf} --with-mozilla-lib-place=$MOZILLA \
				  --with-mozilla-include-place=$MOZILLA/include"

		export MOZILLA_FIVE_HOME=$MOZILLA
		export LD_LIBRARY_PATH=$MOZILLA_FIVE_HOME
	else
		myconf="${myconf} --disable-mozilla-component"
	fi

	libtoolize --copy --force
	aclocal
	autoconf

	CFLAGS="${CFLAGS} `gnome-config --cflags gdk_pixbuf`"

	./configure --host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--enable-eazel-services=0 \
		${myconf} || die

	emake || die
}

src_install() {
	make prefix=${D}/usr \
	     sysconfdir=${D}/etc \
	     localstatedir=${D}/var/lib \
	     install || die

	# Fix missing icon in Gnome Spash
	insinto /usr/share/pixmaps
	newins nautilus-launch-icon.png gnome-launch-icon.png

	dodoc AUTHORS COPYING* ChangeLog* NEWS TODO

	# Fix permissions in order to resolve the mozilla-view issue
	chmod -R g+r,o+r ${D}/*
}

