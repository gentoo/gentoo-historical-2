# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Author: Spider  <spider@gentoo.org>
# Maintainer: Spider <spider@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/gnome-base/gnome-session/gnome-session-1.5.20-r1.ebuild,v 1.1 2002/05/29 22:16:23 spider Exp $

# Do _NOT_ strip symbols in the build! Need both lines for Portage 1.8.9+
DEBUG="yes"
RESTRICT="nostrip"
# force debug information
CFLAGS="${CFLAGS} -g"
CXXFLAGS="${CXXFLAGS} -g"


S=${WORKDIR}/${P}
DESCRIPTION="the Gnome2 session manager"
SRC_URI="ftp://ftp.gnome.org/pub/GNOME/pre-gnome2/sources/gnome-session/${P}.tar.bz2"
HOMEPAGE="http://www.gnome.org/"
SLOT="0"
LICENSE="GPL-2 LGPL-2.1 FDL-1.1"


RDEPEND=">=dev-libs/glib-2.0.0
	>=x11-libs/gtk+-2.0.0
	>=gnome-base/libgnomeui-1.117.2
	>=gnome-base/libgnomecanvas-1.117.0
	>=sys-devel/gettext-0.10.40
	>=sys-apps/tcp-wrappers-7.6"

DEPEND=">=dev-util/pkgconfig-0.12.0
	>=dev-util/intltool-0.17
	${RDEPEND}"

src_compile() {
        # heh, we are a bit quick here.. timezones
	find . -exec touch "{}" \;
	libtoolize --copy --force
	./configure --host=${CHOST} \
		--prefix=/usr \
		--sysconfdir=/etc \
		--infodir=/usr/share/info \
		--mandir=/usr/share/man \
		 --enable-debug=yes || die
	emake || die
}

src_install() {
	export GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL="1"		
	make prefix=${D}/usr \
		sysconfdir=${D}/etc \
		infodir=${D}/usr/share/info \
		mandir=${D}/usr/share/man \
		install || die
	unset GCONF_DISABLE_MAKEFILE_SCHEMA_INSTALL
	# Support for new X session management scheme
	exeinto /etc/X11/Sessions
	doexe ${FILESDIR}/Gnome


 	dodoc AUTHORS COPY* README HACKING INSTALL NEWS TODO ChangeLog 
}


pkg_postinst() {
	export GCONF_CONFIG_SOURCE=`gconftool-2 --get-default-source`
	echo ">>> updating GConf2 (panel)" 
	for SCHEMA in  gnome-session.schemas; do
		echo ${SCHEMA}
		/usr/bin/gconftool-2  --makefile-install-rule \
			/etc/gconf/schemas/${SCHEMA}
	done
}
