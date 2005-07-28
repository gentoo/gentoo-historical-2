# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeaccessibility/kdeaccessibility-3.4.1.ebuild,v 1.6 2005/07/28 07:08:31 gmsoft Exp $

inherit kde-dist eutils

DESCRIPTION="KDE accessibility module"
KEYWORDS="~alpha amd64 ~ia64 ppc sparc x86 hppa"
IUSE="arts gstreamer"

DEPEND="gstreamer? ( >=media-libs/gstreamer-0.8.7 )"

RDEPEND="${DEPEND}
	arts? ( || ( app-accessibility/festival
		     app-accessibility/epos
		     app-accessibility/flite
		     app-accessibility/freetts ) )

	gstreamer? ( || ( app-accessibility/festival
		     app-accessibility/epos
		     app-accessibility/flite ) )"

pkg_setup() {
	kde_pkg_setup
	if use gstreamer; then
		ewarn "gstreamer support in kdeaccessibility is experimental"
	fi
}

src_unpack() {
	kde_src_unpack
	epatch ${FILESDIR}/kdeaccessibility-3.4.0-noarts.patch
}

src_compile() {
	myconf="$(use_enable gstreamer kttsd-gstreamer)"
	kde_src_compile
}
