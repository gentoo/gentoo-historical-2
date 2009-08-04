# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeartwork-meta/kdeartwork-meta-4.3.0.ebuild,v 1.1 2009/08/04 00:06:28 wired Exp $

EAPI="2"

DESCRIPTION="kdeartwork - merge this to pull in all kdeartwork-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.3"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86"
IUSE="kdeprefix"

RDEPEND="
	>=kde-base/kdeartwork-colorschemes-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdeartwork-desktopthemes-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdeartwork-emoticons-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdeartwork-iconthemes-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdeartwork-kscreensaver-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdeartwork-sounds-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdeartwork-styles-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdeartwork-wallpapers-${PV}:${SLOT}[kdeprefix=]
	>=kde-base/kdeartwork-weatherwallpapers-${PV}:${SLOT}[kdeprefix=]
"
