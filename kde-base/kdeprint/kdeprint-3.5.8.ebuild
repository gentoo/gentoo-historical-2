# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeprint/kdeprint-3.5.8.ebuild,v 1.7 2008/03/04 03:16:20 jer Exp $

KMNAME=kdebase
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE printer queue/device manager"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE="cups kde kdehiddenvisibility"

# TODO Makefile reads ppd models from /usr/share/cups/model	 (hardcoded !!)
DEPEND="cups? ( net-print/cups )"
RDEPEND="${DEPEND}
	app-text/enscript
	app-text/psutils
	kde? ( $(deprange-dual $PV $MAXKDEVER kde-base/kghostview) )"

src_compile() {
	myconf="$myconf `use_with cups`"
	kde-meta_src_compile
}
