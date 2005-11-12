# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/artsplugin-xine/artsplugin-xine-3.5.0_beta2.ebuild,v 1.3 2005/11/12 15:49:22 danarmak Exp $

KMNAME=kdemultimedia
KMMODULE=xine_artsplugin
MAXKDEVER=3.5.0_rc1
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="arts xine plugin"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=media-libs/xine-lib-1.0"

pkg_setup() {
	if ! useq arts; then
		eerror "${PN} needs the USE=\"arts\" enabled and also the kdelibs compiled with the USE=\"arts\" enabled"
		die
	fi
}
