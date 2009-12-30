# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emulation/emul-linux-x86-gtklibs/emul-linux-x86-gtklibs-20091226.ebuild,v 1.3 2009/12/30 19:49:23 pacho Exp $

inherit emul-linux-x86

LICENSE="GPL-3 GPL-2 LGPL-2 LGPL-2.1 FTL MIT || ( LGPL-2.1 MPL-1.1 )"
KEYWORDS="-* ~amd64"

IUSE=""

DEPEND=""
RDEPEND="=app-emulation/emul-linux-x86-baselibs-${PV}
	=app-emulation/emul-linux-x86-xlibs-${PV}"

src_unpack() {
	query_tools="${S}/usr/bin/gtk-query-immodules-2.0|${S}/usr/bin/gdk-pixbuf-query-loaders|${S}/usr/bin/pango-querymodules"
	ALLOWED="(${S}/etc/env.d|${S}/etc/gtk-2.0|${S}/etc/pango/i686-pc-linux-gnu|${query_tools})"
	emul-linux-x86_src_unpack

	# these tools generate an index in /etc/{pango,gtk-2.0}/${CHOST}
	mv -f "${S}/usr/bin/pango-querymodules"{,32}
	mv -f "${S}/usr/bin/gtk-query-immodules-2.0"{,-32}
	mv -f "${S}/usr/bin/gdk-pixbuf-query-loaders"{,32}
}

pkg_preinst() {
	#bug 169058
	for l in "${ROOT}/usr/lib32/{pango,gtk-2.0}" ; do
		[[ -L ${l} ]] && rm -f ${l}
	done
}

pkg_postinst() {
	PANGO_CONFDIR="/etc/pango/i686-pc-linux-gnu"
	if [[ ${ROOT} == "/" ]] ; then
		einfo "Generating pango modules listing..."
		mkdir -p ${PANGO_CONFDIR}
		pango-querymodules32 > ${PANGO_CONFDIR}/pango.modules
	fi

	GTK2_CONFDIR="/etc/gtk-2.0/i686-pc-linux-gnu"
	einfo "Generating gtk+ immodules/gdk-pixbuf loaders listing..."
	mkdir -p ${GTK2_CONFDIR}
	gtk-query-immodules-2.0-32 > "${ROOT}${GTK2_CONFDIR}/gtk.immodules"
	gdk-pixbuf-query-loaders32 > "${ROOT}${GTK2_CONFDIR}/gdk-pixbuf.loaders"

	# gdk-pixbuf.loaders should be in their CHOST directories respectively.
	if [[ -e ${ROOT}/etc/gtk-2.0/gdk-pixbuf.loaders ]] ; then
		ewarn
		ewarn "File /etc/gtk-2.0/gdk-pixbuf.loaders shouldn't be present on"
		ewarn "multilib systems, please remove it by hand."
		ewarn
	fi
}
