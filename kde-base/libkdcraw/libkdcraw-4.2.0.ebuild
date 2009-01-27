# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkdcraw/libkdcraw-4.2.0.ebuild,v 1.1 2009/01/27 18:08:08 alexxy Exp $

EAPI="2"

KMNAME="kdegraphics"
KMMODULE="libs/${PN}"

inherit kde4-meta

DESCRIPTION="KDE Image Plugin Interface: a dcraw library wrapper"
HOMEPAGE="http://www.kipi-plugins.org"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND="
	media-libs/jpeg
	media-libs/lcms
"
RDEPEND="${DEPEND}
	!kdeprefix? ( !media-libs/libkdcraw )
"
