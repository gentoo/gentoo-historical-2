# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-applets/gnome-applets-1.4.0.4-r1.ebuild,v 1.6 2002/08/01 11:59:02 seemant Exp $

S=${WORKDIR}/${P}
DESCRIPTION="gnome-applets"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

RDEPEND=">=gnome-base/gnome-core-1.4.0.4-r1
	 >=gnome-base/libgtop-1.0.12-r1
	 >=gnome-base/libghttp-1.0.9-r1"

DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
        >=app-text/scrollkeeper-0.2
        >=dev-util/intltool-0.11"

SLOT="1"
LICENSE="GPL"
KEYWORDS="x86 ppc"

src_compile() {
	local myconf

	use nls || myconf="--disable-nls"

	./configure \
		--host=${CHOST} \
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
