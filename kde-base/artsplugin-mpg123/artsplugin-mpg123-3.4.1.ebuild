# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/artsplugin-mpg123/artsplugin-mpg123-3.4.1.ebuild,v 1.10 2005/09/25 11:57:10 flameeyes Exp $

KMNAME=kdemultimedia
KMMODULE=mpg123_artsplugin
MAXKDEVER=3.4.2
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="aRts plugin for mpg123"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE=""

pkg_setup() {
	if ! useq arts; then
		eerror "${PN} needs the USE=\"arts\" enabled and also the kdelibs compiled with the USE=\"arts\" enabled"
		die
	fi
}

PATCHES="${FILESDIR}/artsplugin-mpg123-mcpu.patch"

