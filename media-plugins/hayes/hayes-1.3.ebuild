# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/hayes/hayes-1.3.ebuild,v 1.7 2004/06/29 12:05:44 carlo Exp $

inherit kde

DESCRIPTION="A filesystem-based Playlist for Noatun 2.0"
SRC_URI="http://www.freekde.org/neil/hayes/${P}.tar.bz2"
HOMEPAGE="http://www.freekde.org/neil/hayes/"

SLOT="0"
LICENSE="MIT"
KEYWORDS="x86"
IUSE=""

DEPEND=">=kde-base/kdemultimedia-3.0"
need-kde 3