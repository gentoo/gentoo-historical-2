# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-pim/gnome-pim-1.4.3.ebuild,v 1.2 2002/07/11 06:30:26 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="gnome-pim"
SRC_URI="http://www.eskil.org/gnome-pilot/download/tarballs/${P}.tar.gz
	 ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPGAE="http://www.gnome.org/gnome-office/gnome-pim.shtml"

RDEPEND=">=gnome-base/gnome-libs-1.4.1.2-r1"

DEPEND="${RDEPEND}
	>=gnome-base/gnome-core-1.4.0.4-r1
	nls? ( sys-devel/gettext )"

src_compile() {
	local myconf

	if [ -z "`use nls`" ] ; then
		myconf="--disable-nls"
	fi

	./configure --host=${CHOST}					\
		    --prefix=/usr					\
		    --sysconfdir=/etc					\
		    --localstatedir=/var/lib				\
		    $myconf || die

	emake || die
}

src_install() {
	make prefix=${D}/usr						\
	     sysconfdir=${D}/etc					\
	     localstatedir=${D}/var/lib					\
	     install || die

	dodoc AUTHORS COPYING* ChangeLog NEWS README*
}
