# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/eclipse-cdt-bin/eclipse-cdt-bin-1.2.0.ebuild,v 1.1 2004/06/03 21:01:25 karltk Exp $

inherit eclipse-ext

DESCRIPTION="C/C++ Development Tools for Eclipse"
HOMEPAGE="http://www.eclipse.org/cdt"
SRC_URI=" gtk? ( http://download.eclipse.org/tools/cdt/updates/release/dist/cdt-full-1.2-linux-gtk.zip )
	  motif? ( http://download.eclipse.org/tools/cdt/updates/release/dist/cdt-full-1.2-linux-motif.zip )"
SLOT="1"
LICENSE="CPL-1.0"
KEYWORDS="-* ~x86"
DEPEND=">=dev-util/eclipse-sdk-3.0_pre8"
RDEPEND="${DEPEND}
	gtk? ( >=x11-libs/gtk+-2.2.4-r1 )
	motif? ( >=x11-libs/openmotif-2.1.30-r4 ) "


src_unpack() {
	if use gtk && use motif ; then
		ewarn "Both gtk and motif desired, selecting gtk."
	fi
	mkdir ${S}
	cd ${S}
	unpack ${A}
}


src_compile() {
	einfo "${P} is a binary package"
}

src_install () {
	eclipse-ext_require-slot 2 || die "Failed to find suitable Eclipse installation"

	eclipse-ext_create-ext-layout binary || die "Failed to create layout"

	eclipse-ext_install-features eclipse/features/* || die "Failed to install features"
	eclipse-ext_install-plugins eclipse/plugins/* || die "Failed to install plugins"
}
