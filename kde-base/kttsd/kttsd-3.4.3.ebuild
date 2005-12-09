# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kttsd/kttsd-3.4.3.ebuild,v 1.6 2005/12/09 03:51:43 josejx Exp $
KMNAME=kdeaccessibility
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta eutils

DESCRIPTION="KDE text-to-speech subsystem"
KEYWORDS="~alpha amd64 ppc ppc64 sparc ~x86"
IUSE="gstreamer"
DEPEND="arts? ( $(deprange $PV $MAXKDEVER kde-base/arts) )
	$(deprange-dual $PV $MAXKDEVER kde-base/kcontrol)
	gstreamer? ( =media-libs/gstreamer-0.8* )
	>=dev-util/pkgconfig-0.9.0"

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
	kde-meta_src_unpack
	epatch ${FILESDIR}/kdeaccessibility-3.4.0-noarts.patch
}

src_compile() {
	myconf="$(use_enable gstreamer kttsd-gstreamer)"
	kde-meta_src_compile
}
