# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/gnome-base/libgnomeui/libgnomeui-1.117.2-r1.ebuild,v 1.1 2002/06/05 21:09:05 spider Exp $



# Author and maintainer : Spider  <spider@gentoo.org>
# Do _NOT_ strip symbols in the build! Need both lines for Portage 1.8.9+
DEBUG="yes"
RESTRICT="nostrip"
# force debug information
export CFLAGS="${CFLAGS/-fomit-frame-pointer/} -g"
export CXXFLAGS="${CXXFLAGS/-fomit-frame-pointer/} -g"


S=${WORKDIR}/${P}
DESCRIPTION="User interface part of libgnome"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/pre-gnome2/sources/${PN}/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1" 

RDEPEND=">=x11-libs/gtk+-2.0.2
	>=sys-devel/perl-5.0.0
	>=sys-apps/gawk-3.1.0
	>=dev-libs/popt-1.6.0
	>=sys-devel/bison-1.28
	>=sys-devel/gettext-0.10.40
	>=media-sound/esound-0.2.23
	>=media-libs/audiofile-0.2.3
	>=gnome-base/libbonoboui-1.117.1
	>=gnome-base/gconf-1.1.10
	>=gnome-base/libgnome-1.117.2
	>=gnome-base/libgnomecanvas-1.117.0"

DEPEND="${RDEPEND}
	>=dev-util/pkgconfig-0.12.0
	doc? ( >=dev-util/gtk-doc-0.9-r2 )"


src_unpack() {
	unpack ${A}
	cd ${S}
	patch -p0 <${FILESDIR}/libgnomeui-1.117.2-void.patch
}


src_compile() {
	libtoolize --copy --force
	local myconf
	use doc && myconf="${myconf} --enable-gtk-doc" || myconf="${myconf} --disable-gtk-doc"
	./configure --host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		${myconf} --enable-debug=yes || die "configure failure"

	emake || die "compile failure" 
}

src_install() {
	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		infodir=${D}/usr/share/info \
		mandir=${D}/usr/share/man \
		install || die
    
# 	dodoc AUTHORS ChangeLog COPYING README* INSTALL NEWS NEWS.pre-1-3 TODO.xml
}





