# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libkface/libkface-2.4.1.ebuild,v 1.3 2012/01/16 23:57:18 ago Exp $

EAPI=4

DIGIKAMPN=digikam

KDE_LINGUAS=""
KDE_MINIMAL="4.7"

CMAKE_MIN_VERSION=2.8

inherit kde4-base

MY_P="${DIGIKAMPN}-${PV/_/-}"

DESCRIPTION="Qt/C++ wrapper around LibFace to perform face recognition and detection"
HOMEPAGE="http://www.digikam.org/"
SRC_URI="mirror://sourceforge/${DIGIKAMPN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"
IUSE=""
SLOT=4

DEPEND=">=media-libs/opencv-2.1"
RDEPEND=${DEPEND}

S=${WORKDIR}/${MY_P}/extra/${PN}

src_configure() {
	mycmakeargs=(
		-DFORCED_UNBUNDLE=ON
	)
	kde4-base_src_configure
}
