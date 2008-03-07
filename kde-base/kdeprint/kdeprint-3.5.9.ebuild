# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeprint/kdeprint-3.5.9.ebuild,v 1.3 2008/03/07 20:36:16 ingmar Exp $

KMNAME=kdebase
EAPI="1"
inherit kde-meta eutils

DESCRIPTION="KDE printer queue/device manager"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="cups kde kdehiddenvisibility"

# TODO Makefile reads ppd models from /usr/share/cups/model	 (hardcoded !!)
DEPEND="cups? ( net-print/cups )"
RDEPEND="${DEPEND}
	app-text/enscript
	app-text/psutils
	kde? ( || ( >=kde-base/kghostview-${PV}:${SLOT} >=kde-base/kdegraphics-${PV}:${SLOT} ) )"

src_compile() {
	myconf="$myconf $(use_with cups)"
	kde-meta_src_compile
}
