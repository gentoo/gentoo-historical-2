# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/artsplugin-akode/artsplugin-akode-3.5.0.ebuild,v 1.3 2005/12/04 00:48:05 kloeri Exp $

KMNAME=kdemultimedia
KMMODULE=akode_artsplugin
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="akode arts plugin"
KEYWORDS="~alpha ~amd64 ~sparc ~x86"
IUSE=""
DEPEND="media-libs/akode
	$(deprange $PV $MAXKDEVER kde-base/kdemultimedia-arts)"

KMCOPYLIB="libartsbuilder arts/runtime"

pkg_setup() {
	if ! useq arts; then
		eerror "${PN} needs the USE=\"arts\" enabled and also the kdelibs compiled with the USE=\"arts\" enabled"
		die
	fi
}

src_compile() {
	local myconf="--with-akode"

	kde-meta_src_compile
}
