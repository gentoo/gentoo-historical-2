# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libkexif/libkexif-0.2.1.ebuild,v 1.1 2005/01/04 21:37:35 carlo Exp $

inherit kde

DESCRIPTION="A KDE library for loss-less EXIF operations."
HOMEPAGE="http://digikam.sourceforge.net/"
SRC_URI="mirror://sourceforge/digikam/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~x86 ~ppc ~amd64"
IUSE=""

DEPEND="media-libs/libexif
	dev-util/pkgconfig"
RDEPEND="media-libs/libexif"
need-kde 3.1
