# Copyright 1999-2000 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-extra/medusa/medusa-0.5.1-r3.ebuild,v 1.2 2002/07/11 06:30:26 drobbins Exp $

S=${WORKDIR}/${P}
DESCRIPTION="Medusa search system for GNOME"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/stable/sources/${PN}/${P}.tar.gz"
HOMEPAGE="http://www.gnome.org/"

DEPEND=">=gnome-base/gnome-vfs-1.0.2-r1
		nls? ( >=dev-util/intltool-0.11 sys-devel/gettext )
		dev-libs/libxml
		gnome-base/gnome-libs"

src_compile() {

	local myconf

	use nls || myconf="${myconf} --disable-nls"

	CFLAGS="${CFLAGS} -I/usr/include/gnome-1.0"

	./configure --host=${CHOST} 					\
		    --prefix=/usr					\
		    --sysconfdir=/etc					\
		    --mandir=/usr/share/man				\
		    --infodir=/usr/share/info				\
		    --sharedstatedir=/var/lib 				\
		    --localstatedir=/var/lib 				\
		    --enable-prefer-db1 			\
			${myconf} || die

	# uid_t and gid_t is not #defined, fix
	mv libmedusa/medusa-file-info-utilities.h \
		libmedusa/medusa-file-info-utilities.h.orig
	sed -e 's/uid_t/__uid_t/' \
		-e 's/gid_t/__gid_t/' \
		libmedusa/medusa-file-info-utilities.h.orig \
		> libmedusa/medusa-file-info-utilities.h

	emake medusainitdir=/tmp || die
}

src_install() {
	make DESTDIR=${D} medusainitdir=/tmp install || die

	dodoc ABOUT-NLS AUTHORS COPYING ChangeLog INSTALL NEWS README THANKS TODO
}

