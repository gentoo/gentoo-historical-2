# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libkdcraw/libkdcraw-4.1.2.ebuild,v 1.1 2008/10/02 10:41:22 jmbsvicetto Exp $

EAPI="2"

KMNAME="kdegraphics"
KMMODULE=libs/libkdcraw

inherit kde4-meta

DESCRIPTION="KDE Image Plugin Interface: a dcraw library wrapper"
HOMEPAGE="http://www.kipi-plugins.org"

KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/jpeg
	media-libs/lcms
	!kdeprefix? ( !media-libs/libkdcraw )"
RDEPEND="${DEPEND}"

