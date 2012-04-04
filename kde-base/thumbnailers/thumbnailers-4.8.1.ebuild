# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/thumbnailers/thumbnailers-4.8.1.ebuild,v 1.2 2012/04/04 19:29:15 ago Exp $

EAPI=4

KDE_SCM="git"
KMNAME="kdegraphics-thumbnailers"
inherit kde4-base

DESCRIPTION="KDE 4 thumbnail generators for PDF/PS files"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep libkdcraw)
	$(add_kdebase_dep libkexiv2)
	media-libs/lcms:0
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${KMNAME}-${PV}"
