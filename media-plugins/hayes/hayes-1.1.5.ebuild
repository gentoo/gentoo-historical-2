# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/hayes/hayes-1.1.5.ebuild,v 1.3 2003/02/13 12:58:18 vapier Exp $

inherit kde-base 

DESCRIPTION="A filesystem-based Playlist for Noatun 2.0"
SRC_URI="http://www.freekde.org/neil/hayes/${P}.tar.bz2"
HOMEPAGE="http://www.freekde.org/neil/hayes/"

LICENSE="MIT"
KEYWORDS="x86"

need-kde 3

newdepend ">=kde-base/kdemultimedia-3.0"
