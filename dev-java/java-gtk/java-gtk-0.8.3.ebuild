# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/java-gtk/java-gtk-0.8.3.ebuild,v 1.6 2004/07/16 13:27:39 axxo Exp $

inherit java-pkg

DESCRIPTION="GTK+ bindings for Java"
SRC_URI="mirror://sourceforge/java-gnome/libgtk-java-${PV}.tar.bz2"
HOMEPAGE="http://java-gnome.sourceforge.net/"
DEPEND="virtual/libc
		virtual/jdk
		>=x11-libs/gtk+-2.2*
		>=app-text/docbook-sgml-utils-0.6.12
		>=gnome-base/libgnomeui-2.0
		>=gnome-base/libglade-2.0"

SLOT="0.8"
IUSE="gcj"
LICENSE="LGPL-2.1"
KEYWORDS="x86 ~ppc ~sparc"

S=${WORKDIR}/libgtk-java-${PV}

src_compile() {
	./configure \
		--host=${CHOST} \
		--prefix=/usr \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		$(use_with gcj gcj-compile) \
		--with-java-prefix=${JAVA_HOME} || die "./configure failed"

	make || die
}

src_install() {
	make prefix=${D}/usr install || die

	dodir /usr/share/${PN}/lib
	mv ${D}/usr/share/${PN}/*.jar ${D}/usr/share/${PN}/lib/

	echo "DESCRIPTION=${DESCRIPTION}" \
		> ${D}/usr/share/${PN}/package.env

	echo "CLASSPATH=/usr/share/java-gnome/lib/gtk${SLOT}.jar"\
		>> ${D}/usr/share/${PN}/package.env
}
