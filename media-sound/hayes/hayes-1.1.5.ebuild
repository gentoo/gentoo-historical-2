# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/hayes/hayes-1.1.5.ebuild,v 1.1 2002/10/24 19:48:01 hannes Exp $

inherit kde-base 

DESCRIPTION="A filesystem-based Playlist for Noatun 2.0"
SRC_URI="http://www.freekde.org/neil/hayes/${P}.tar.bz2"
HOMEPAGE="http://www.freekde.org/neil/hayes/"

LICENSE="X11"
KEYWORDS="~x86"

need-kde 3

newdepend ">=kde-base/kdemultimedia-3.0"
