# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-gnome/java-gnome-2.6.0.1-r1.ebuild,v 1.5 2005/02/17 17:33:53 luckyduck Exp $

inherit eutils

DESCRIPTION="Java bindings for GNOME and GTK libraries that allow GNOME and GTK applications to be written in Java"
SRC_URI="mirror://sourceforge/java-gnome/${P}.tar.bz2"
HOMEPAGE="http://java-gnome.sourceforge.net/"
DEPEND="virtual/libc
		>=gnome-base/libgnome-2.6.0
		>=gnome-base/libgnomeui-2.6.0
		>=gnome-base/libgnomecanvas-2.6.0
		=gnome-extra/libgtkhtml-2.6*
		>=gnome-base/libglade-2.3.6
		>=gnome-base/gconf-2.6.0
		virtual/jdk
		app-text/docbook-sgml
		>=app-text/docbook-sgml-utils-0.6.12
		x11-libs/vte
		app-arch/zip"
SLOT="2.6"
LICENSE="LGPL-2.1"
KEYWORDS="~x86 ~ppc"
IUSE=""

src_unpack() {
	unpack ${A}
	cd ${S} && epatch ${FILESDIR}/gentoo-java-gnome-2.6.0.1.patch || die "epatch failed"
}

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		--without-gcj-compile \
		--with-java-prefix=${JAVA_HOME} || die "./configure failed"
	make || die
}

src_install() {
	make prefix=${D}/usr install || die

	dodir /usr/share/java-gnome/lib
	mv ${D}/usr/share/java-gnome/*.jar ${D}/usr/share/java-gnome/lib/

	cd ${S}/atk/src/java
	zip -r ${D}/usr/share/java-gnome/lib/gtk-${PV}.src.zip *
	cd ${S}/gdk/src/java
	zip -r ${D}/usr/share/java-gnome/lib/gtk-${PV}.src.zip *
	cd ${S}/gtk/src/java
	zip -r ${D}/usr/share/java-gnome/lib/gtk-${PV}.src.zip *
	cd ${S}/glib/src/java
	zip -r ${D}/usr/share/java-gnome/lib/gtk-${PV}.src.zip *
	cd ${S}/pango/src/java
	zip -r ${D}/usr/share/java-gnome/lib/gtk-${PV}.src.zip *

	cd ${S}/gnome/src/java
	zip -r ${D}/usr/share/java-gnome/lib/gnome-${PV}.src.zip *

	cd ${S}/gtkhtml/src/java
	zip -r ${D}/usr/share/java-gnome/lib/gtkhtml-${PV}.src.zip *

	cd ${S}/glade/src/java
	zip -r ${D}/usr/share/java-gnome/lib/glade-${PV}.src.zip *

	cd ${S}/gconf/src/java
	zip -r ${D}/usr/share/java-gnome/lib/gconf-${PV}.src.zip *

	cd ${S}/vte/src/java
	zip -r ${D}/usr/share/java-gnome/lib/gnomevte-${PV}.src.zip *

	dosym /usr/share/java-gnome/lib/gnome${SLOT}-${PV%.*}.jar /usr/share/java-gnome/lib/gnome${SLOT}.jar

	dosym /usr/lib/libgnomejava${SLOT}.so.${PV%.*} /usr/lib/libgnomejava${SLOT}.so

	echo "DESCRIPTION=${DESCRIPTION}" \
		> ${D}/usr/share/java-gnome/package.env

	echo "CLASSPATH=/usr/share/java-gnome/lib/gtk${SLOT}.jar:/usr/share/java-gnome/lib/gnome${SLOT}.jar:/usr/share/java-gnome/lib/glade${SLOT}.jar:/usr/share/java-gnome/lib/gconf${SLOT}.jar:/usr/share/java-gnome/lib/gnomevte${SLOT}.jar:/usr/share/java-gnome/lib/gtkhtml${SLOT}.jar" \
		>> ${D}/usr/share/java-gnome/package.env
}
