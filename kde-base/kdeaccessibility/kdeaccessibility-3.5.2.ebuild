# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeaccessibility/kdeaccessibility-3.5.2.ebuild,v 1.4 2006/05/26 21:28:17 corsair Exp $

inherit kde-dist

DESCRIPTION="KDE accessibility module"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ppc64 ~sparc x86"
IUSE="alsa gstreamer"

DEPEND="media-libs/akode
	alsa? ( media-libs/alsa-lib )
	gstreamer? ( =media-libs/gstreamer-0.8*
	             =media-libs/gst-plugins-0.8* )"

RDEPEND="${DEPEND}
	|| ( app-accessibility/festival
	     app-accessibility/epos
	     app-accessibility/flite
	     app-accessibility/freetts )"

DEPEND="${DEPEND}
	dev-util/pkgconfig"

src_compile() {
	local myconf="--with-akode
	             $(use_with alsa) $(use_with gstreamer)"

	kde_src_compile
}
