# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/emotion/emotion-9999.ebuild,v 1.4 2005/10/02 19:38:24 vapier Exp $

inherit enlightenment

DESCRIPTION="video libraries for e17"

IUSE="gstreamer xine"

DEPEND=">=dev-libs/eet-0.9.9
	>=x11-libs/evas-0.9.9
	>=media-libs/edje-0.5.0
	>=x11-libs/ecore-0.9.9
	>=dev-libs/embryo-0.9.1
	xine? ( >=media-libs/xine-lib-1_rc5 )
	!gstreamer? ( !xine? ( >=media-libs/xine-lib-1_rc5 ) )
	gstreamer? ( =media-libs/gstreamer-0.8* )"

src_compile() {
	if ! use xine && ! use gstreamer ; then
		export MY_ECONF="--enable-xine --disable-gstreamer"
	else
		export MY_ECONF="
			$(use_enable xine) \
			$(use_enable gstreamer) \
		"
	fi
	enlightenment_src_compile
}
