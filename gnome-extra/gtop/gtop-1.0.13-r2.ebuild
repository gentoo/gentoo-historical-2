# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gtop/gtop-1.0.13-r2.ebuild,v 1.13 2004/06/03 22:58:26 agriffis Exp $

inherit eutils

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="gtop"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 sparc ppc"

DEPEND="( >=gnome-base/libgtop-1.0.12-r1
	 <gnome-base/libgtop-2.0.0 )
	>=gnome-base/gnome-libs-1.4.1.7
	nls? ( sys-devel/gettext )"

src_unpack() {

	unpack ${A}

	epatch ${FILESDIR}/${PN}-1-gcc33_fix.patch

}

src_compile() {
	local myconf

	if ! use nls ; then
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

	dodoc AUTHORS COPYING ChangeLog NEWS README TODO
}

