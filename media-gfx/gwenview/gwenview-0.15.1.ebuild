# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gwenview/gwenview-0.15.1.ebuild,v 1.4 2003/07/12 16:44:48 aliz Exp $

inherit kde-base

DESCRIPTION="image viewer for KDE"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://gwenview.sourceforge.net/"

LICENSE="GPL-2"
KEYWORDS="x86"

need-kde 3

newdepend ">=kde-base/kdebase-3.0"
