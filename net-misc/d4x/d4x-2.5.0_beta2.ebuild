# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/d4x/d4x-2.5.0_beta2.ebuild,v 1.1 2003/08/31 14:54:23 liquidx Exp $

IUSE="nls esd gnome oss kde"

inherit eutils

S="${WORKDIR}/${P/_}"
DESCRIPTION="GTK based download manager for X."
SRC_URI="http://www.krasu.ru/soft/chuchelo/files/${P/_}.tar.gz"
HOMEPAGE="http://www.krasu.ru/soft/chuchelo/"

KEYWORDS="~x86"
SLOT="0"
LICENSE="Artistic"

DEPEND=">=x11-libs/gtk+-2.0.6
	>=dev-libs/glib-2.0.6
	>=sys-devel/gettext-0.11.2    
	esd? ( >=media-sound/esound-0.2.7 )"

src_unpack() {

	unpack ${A}

	# Use our own $CXXFLAGS
	cd ${S}
	cp configure configure.orig
	sed -e "s:CXXFLAGS=\"-O2\":CXXFLAGS=\"${CXXFLAGS}\":g;s:OPTFLAGS=\"-O2\":OPTFLAGS=\"\":g" \
		configure.orig >configure

	# Fix a miscompile with gcc-3.2.2 and CFLAGS="-O2"
	# <azarah@gentoo.org> (30 Mar 2003)
	epatch ${FILESDIR}/${PN}-2.4.1-fix-statusbar-crash.patch
}

src_compile() {

	myconf=""
	
	use nls \
		&& myconf="${myconf} --enable-nls" \
		|| myconf="${myconf} --disable-nls"
	
	use esd \
		&& myconf="${myconf} --enable-esd" \
		|| myconf="${myconf} --disable-esd"
	
	use oss \
		&& myconf="${myconf} --enable-oss" \
		|| myconf="${myconf} --disable-oss"

	econf --enable-release \
		${myconf} || die
		
	emake || die
}

src_install () {

	dodir /usr/bin
	dodir /usr/share/d4x

	einstall || die

	insinto /usr/share/pixmaps
	doins share/*.png share/*.xpm

	if [ -n "`use kde`" ]
	then
		insinto /usr/share/applnk/Internet
		newins share/nt.desktop d4x.desktop
	fi

	if [ -n "`use gnome`" ]
	then
        echo "Categories=Application;Network;" >> ${S}/share/nt.desktop
		insinto /usr/share/applications
		newins share/nt.desktop d4x.desktop
	fi

	rm -rf ${D}/usr/share/d4x/{FAQ*,INSTALL*,README*,LICENSE,NAMES,TROUBLES}
	dodoc AUTHORS COPYING ChangeLog* NEWS PLANS TODO \
		DOC/{FAQ*,LICENSE,NAMES,README*,TROUBLES,THANKS}
}

