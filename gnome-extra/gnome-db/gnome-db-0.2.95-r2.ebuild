# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-db/gnome-db-0.2.95-r2.ebuild,v 1.8 2003/02/13 12:17:51 vapier Exp $

IUSE="nls"

S=${WORKDIR}/${P}
DESCRIPTION="Framework for creating database applications"
SRC_URI="ftp://ftp.gnome-db.org/pub/gnome-db/sources/latest/${P}.tar.gz
	ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/gnome-office/gnomedb.shtml"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1"
KEYWORDS="x86 sparc "

RDEPEND=">=gnome-base/bonobo-1.0.9-r1
	 >=gnome-extra/libgda-${PV}
	 >=gnome-extra/gal-0.13-r1
	 nls? ( sys-devel/gettext )"

DEPEND="${RDEPEND}
	>=dev-util/intltool-0.11"


src_compile() {
	local myopts

	if [ "`use nls`" ]
	then 
		myopts="--enable-nls"
	else
		myopts="--disable-nls"
	fi

	./configure --host=${CHOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--sysconfdir=/etc \
		--localstatedir=/var/lib \
		--disable-bonobotest \
		${myopts} || die
	emake || die
}

src_install() {
	cd ${S}/doc
	cp Makefile Makefile.orig
	sed -e "s:scrollkeeper-update.*::g" Makefile.orig > Makefile
	rm -f Makefile.orig
	cd ${S}

	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		mandir=${D}/usr/share/man \
		localstatedir=${D}/var/lib \
		localedir=${D}/usr/share/locale \
		GNOME_sysconfdir=${D}/etc \
		GNOME_datadir=${D}/usr/share \
		GNOMEDB_oafinfodir=${D}/usr/share/oaf \
		GNOMEDB_oafdir=${D}/usr/share/oaf \
		install || die
	dodoc AUTHORS COPYING ChangeLog README
}

pkg_postinst() {
	echo ">>> Updating Scrollkeeper database..."
	scrollkeeper-update >/dev/null 2>&1
}

pkg_postrm() {
	echo ">>> Updating Scrollkeeper database..."
	scrollkeeper-update >/dev/null 2>&1
}
		
