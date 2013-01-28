# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/nsplugins/nsplugins-4.9.5.ebuild,v 1.4 2013/01/28 00:05:22 ago Exp $

EAPI=4

KMNAME="kde-baseapps"
inherit kde4-meta pax-utils

DESCRIPTION="Netscape plugins support for Konqueror."
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	x11-libs/libXt
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep konqueror)
"

KMEXTRACTONLY="
	konqueror/settings/
"

src_install() {
	kde4-base_src_install

	# bug 419513
	pax-mark m "${ED}"/usr/bin/nspluginviewer
}
