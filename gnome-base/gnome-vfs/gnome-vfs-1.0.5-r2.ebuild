# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-vfs/gnome-vfs-1.0.5-r2.ebuild,v 1.12 2002/12/16 22:48:17 agriffis Exp $

IUSE="ssl nls"

inherit libtool

S=${WORKDIR}/${P}
DESCRIPTION="GNOME Virtual File System."
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/sources/${PN}/1.0/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

SLOT="1"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="x86 ppc sparc ~alpha"

RDEPEND="( =gnome-base/gconf-1.0* )	
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
	elibtoolize
	if [ -z "`use nls`" ]
	then
		myconf="${myconf} --disable-nls"
		mkdir intl
		touch intl/libgettext.h
	fi
	
	econf ${myconf} || die
	emake || die
}

src_install() {
	einstall || die

	dodoc AUTHORS COPYING* ChangeLog NEWS README
}
