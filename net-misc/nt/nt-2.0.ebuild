# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Martin Schlemmer <azarah@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/net-misc/nt/nt-2.0.ebuild,v 1.6 2002/07/09 10:05:47 phoenix Exp $

#name of tarball changed
MY_P="${P/nt/d4x}"
#handle release candidates
MY_P="${MY_P/_rc/RC}"
S="${WORKDIR}/${MY_P}"
DESCRIPTION="GTK based download manager for X."
SRC_URI="http://www.krasu.ru/soft/chuchelo/files/${MY_P}.tar.gz"
HOMEPAGE="http://www.krasu.ru/soft/chuchelo/"
KEYWORDS="x86"
LICENSE="nt"

DEPEND="=x11-libs/gtk+-1.2*
	>=dev-libs/glib-1.2.10
	>=media-libs/gdk-pixbuf-0.2.5
	esd? ( >=media-sound/esound-0.2.7 )"

SLOT="0"


src_unpack() {

	unpack ${A}

	# Use our own $CXXFLAGS
	cd ${S}
	cp configure configure.orig
	sed -e "s:CXXFLAGS=\"-O2\":CXXFLAGS=\"${CXXFLAGS}\":g" \
		configure.orig >configure

	patch -p1 <${FILESDIR}/nt-2.0-gcc31.patch || die
}

src_compile() {

	myconf=""
	use nls || myconf="${myconf} --disable-nls"
	use esd || myconf="${myconf} --disable-esd"
	use oss || myconf="${myconf} --disable-oss"

	./configure --host=${HOST} \
		--prefix=/usr \
		--mandir=/usr/share/man \
		--infodir=/usr/share/info \
		--enable-release \
		${myconf} || die
		
	emake || die
}

src_install () {

	dodir /usr/bin
	dodir /usr/share/d4x
	
	make prefix=${D}/usr \
		mandir=${D}/usr/share/man \
		infodir=${D}/usr/share/info \
		install || die
   
	dodoc AUTHORS COPYING ChangeLog* NEWS PLANS README TODO
	cd ${S}/DOC
	dodoc FAQ* LICENSE NAMES TROUBLES THANKS

	cd ${S}
	insinto /usr/share/pixmaps
	doins *.png *.xpm

	if [ "`use gnome`" ] ; then
		insinto /usr/share/gnome/apps/Internet
		doins nt.desktop
	fi
}

