# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kaboodle/kaboodle-3.5.0.ebuild,v 1.5 2005/12/17 13:55:15 corsair Exp $

KMNAME=kdemultimedia
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="The Lean KDE Media Player"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

OLDRDEPEND="~kde-base/kdemultimedia-arts-$PV"
RDEPEND="$(deprange $PV $MAXKDEVER kde-base/kdemultimedia-arts)"

KMEXTRACTONLY="arts/"

pkg_setup() {
	if ! useq arts; then
		eerror "${PN} needs the USE=\"arts\" enabled and also the kdelibs compiled with the USE=\"arts\" enabled"
		die
	fi
}
