# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeaccessibility/kdeaccessibility-3.4.0_rc1.ebuild,v 1.3 2005/03/07 23:18:52 greg_g Exp $

inherit kde-dist

DESCRIPTION="KDE accessibility module"
KEYWORDS="~x86 ~amd64 ~sparc"
IUSE="arts"

DEPEND="gstreamer? ( >=media-libs/gstreamer-0.8.7 )"

RDEPEND="${DEPEND}
	arts? ( || ( app-accessibility/festival
		     app-accessibility/epos
		     app-accessibility/flite
		     app-accessibility/freetts ) )"

src_compile() {
	myconf="$(use_enable gstreamer kttsd-gstreamer)"

	kde_src_compile
}
