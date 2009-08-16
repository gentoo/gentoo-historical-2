# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libkexiv2/libkexiv2-0.1.8-r1.ebuild,v 1.6 2009/08/16 11:12:00 armin76 Exp $

ARTS_REQUIRED="never"

inherit kde

DESCRIPTION="KDE Image Plugin Interface: An exiv2 library wrapper."
HOMEPAGE="http://www.kipi-plugins.org"
SRC_URI="mirror://sourceforge/kipi/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

DEPEND=">=media-gfx/exiv2-0.18"
RDEPEND="${DEPEND}"

need-kde 3.5
