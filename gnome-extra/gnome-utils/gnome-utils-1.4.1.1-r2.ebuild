# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author Achim Gottinger <achim@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/gnome-utils/gnome-utils-1.4.1.1-r2.ebuild,v 1.2 2002/01/06 14:54:19 gbevin Exp $

S=${WORKDIR}/${P}
DESCRIPTION="gnome-utils"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

RDEPEND=">=gnome-base/gnome-core-1.4.0.4-r1
		 >=gnome-base/libgtop-1.0.12-r1
		 >=gnome-base/libglade-0.17-r1
		 >=sys-apps/e2fsprogs-1.19-r2"

DEPEND="${RDEPEND}
		>=dev-util/guile-1.5
		>=sys-apps/shadow-20000000
		nls? ( sys-devel/gettext )"


src_unpack() {

	unpack ${A}
	
	# Fix compile error with >=dev-util/guile-1.5
	# NOTE: someone with guile coding experience should verify that
	#       scm_num2dbl is used correctly!
	cd ${S}
	cp gtt/ghtml.c gtt/ghtml.c.orig
	sed -e 's:SCM_NUM2DBL (node):scm_num2dbl (node, "ghtml"):' \
		gtt/ghtml.c.orig >gtt/ghtml.c
}

src_compile() {

	local myconf
	use nls || myconf="--disable-nls"
	CFLAGS="${CFLAGS} `gnome-config --cflags libglade`"
	
	./configure --host=${CHOST}  \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--with-ncurses  \
		--with-messages=/var/log/syslog.d/current  \
		--localstatedir=/var/lib \
		--sysconfdir=/etc \
		$myconf || die
				
	emake || die
}

src_install() {

	# scrollkeeper again ....
	addwrite "/var/lib/scrollkeeper/"

	make DESTDIR=${D} install || die
	dodoc AUTHORS COPYING* ChangeLog NEWS README*
}

pkg_postinst() {

	echo ">>> Updating Scrollkeeper database..."
	scrollkeeper-update >/dev/null 2>&1
}

pkg_postrm() {

	echo ">>> Updating Scrollkeeper database..."
	scrollkeeper-update >/dev/null 2>&1
}
