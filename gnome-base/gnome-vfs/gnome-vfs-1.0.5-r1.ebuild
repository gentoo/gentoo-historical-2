# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-vfs/gnome-vfs-1.0.5-r1.ebuild,v 1.8 2002/10/04 05:34:32 vapier Exp $

S=${WORKDIR}/${P}
DESCRIPTION="GNOME Virtual File System."
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="x86 sparc sparc64"
SLOT="1"

RDEPEND="( >=gnome-base/gconf-1.0.6
			<gnome-base/gconf-1.1 )	
	 >=gnome-base/gnome-libs-1.4.1.2
	 >=gnome-base/gnome-mime-data-1.0.1
	 >=sys-apps/bzip2-1.0.2
	 ssl? ( dev-libs/openssl )"


DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.8.0
	>=dev-util/intltool-0.11
	nls? ( sys-devel/gettext )"

src_compile() {
	local myconf
	libtoolize --force --copy
	if [ -z "`use nls`" ]
	then
		myconf="${myconf} --disable-nls"
		mkdir intl
		touch intl/libgettext.h
	fi
	
	./configure --host=${CHOST} \
		    --prefix=/usr \
		    --sysconfdir=/etc \
		    --localstatedir=/var/lib \
		    ${myconf} || die

	emake || die
}

src_install() {
	make prefix=${D}/usr \
	     sysconfdir=${D}/etc \
	     localstatedir=${D}/var/lib \
	     install || die

	dodoc AUTHORS COPYING* ChangeLog NEWS README
}
