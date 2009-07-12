# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kttsd/kttsd-3.5.10.ebuild,v 1.6 2009/07/12 13:16:34 armin76 Exp $
KMNAME=kdeaccessibility
EAPI="1"
inherit kde-meta

DESCRIPTION="KDE text-to-speech subsystem"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE="akode alsa"

DEPEND="akode? ( media-libs/akode )
	alsa? ( media-libs/alsa-lib )
	|| ( >=kde-base/kcontrol-${PV}:${SLOT} >=kde-base/kdebase-${PV}:${SLOT} )
	!arts? ( !alsa? ( media-libs/akode ) )"
RDEPEND="${DEPEND}
	|| ( app-accessibility/festival
		app-accessibility/epos
		app-accessibility/flite
		app-accessibility/freetts )"

pkg_setup() {
	kde_pkg_setup
	if ! use arts && ! use alsa && ! use akode ; then
		ewarn "No audio backend chosen. Defaulting to media-libs/akode."
	fi
}

src_compile() {
	local myconf="$(use_with alsa) --without-gstreamer"

	if ! use arts && ! use alsa ; then
		myconf="${myconf} --with-akokde"
	else
		myconf="${myconf} $(use_with akode)"
	fi

	kde-meta_src_compile
}
