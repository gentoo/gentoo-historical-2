# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-gtklibs/emul-linux-x86-gtklibs-10.0.ebuild,v 1.2 2007/02/27 10:56:05 blubb Exp $

inherit emul-libs

SRC_URI="mirror://gentoo/atk-1.12.3.tbz2
	mirror://gentoo/cairo-1.2.4.tbz2
	mirror://gentoo/gtk+-1.2.10-r12.tbz2
	mirror://gentoo/gtk+-2.10.6.tbz2
	mirror://gentoo/gtk-engines-2.8.2.tbz2
	mirror://gentoo/gtk-engines-qt-0.7-r1.tbz2
	mirror://gentoo/gtk-engines-xfce-2.2.8-r1.tbz2
	mirror://gentoo/imlib-1.9.14-r3.tbz2
	mirror://gentoo/pango-1.14.9.tbz2"

LICENSE="GPL-2 LGPL-2 LGPL-2.1 FTL || ( LGPL-2.1 MPL-1.1 )"
KEYWORDS="-* ~amd64"

DEPEND=""
RDEPEND=">=app-emulation/emul-linux-x86-baselibs-10.0
	>=app-emulation/emul-linux-x86-qtlibs-10.0
	>=app-emulation/emul-linux-x86-xlibs-10.0"

src_unpack() {
	query_tools="${S}/usr/bin/gtk-query-immodules-2.0|${S}/usr/bin/gdk-pixbuf-query-loaders|${S}/usr/bin/pango-querymodules"
	ALLOWED="(${S}/etc/env.d|${S}/etc/gtk-2.0|${S}/etc/pango/i686-pc-linux-gnu|${query_tools})"
	emul-libs_src_unpack

	# these tools generate an index in /etc/{pango,gtk-2.0}/${CHOST}
	mv -f "${S}/usr/bin/pango-querymodules"{,32}
	mv -f "${S}/usr/bin/gtk-query-immodules-2.0"{,-32}
	mv -f "${S}/usr/bin/gdk-pixbuf-query-loaders"{,32}

	rm -f ${S}/usr/lib32/kde3/kcm_kcmgtk.so
}

pkg_postinst() {
	PANGO_CONFDIR="/etc/pango/i686-pc-linux-gnu"
	if [[ ${ROOT} == "/" ]] ; then
		einfo "Generating pango modules listing..."
		mkdir -p ${PANGO_CONFDIR}
		pango-querymodules32 > ${PANGO_CONFDIR}/pango.modules
	else
		ewarn "You'll have to run the following command after chrooting into ${ROOT}:"
		ewarn "pango-querymodules32 > ${PANGO_CONFDIR}/pango.modules"
	fi

	GTK2_CONFDIR="/etc/gtk-2.0/i686-pc-linux-gnu"
	einfo "Generating gtk+ immodules/gdk-pixbuf loaders listing..."
	mkdir -p ${GTK2_CONFDIR}
	gtk-query-immodules-2.0-32 > ${ROOT}${GTK2_CONFDIR}/gtk.immodules
	gdk-pixbuf-query-loaders32 > ${ROOT}${GTK2_CONFDIR}/gdk-pixbuf.loaders
}
