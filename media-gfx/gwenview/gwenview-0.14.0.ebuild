# Copyright 1999-2002 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gwenview/gwenview-0.14.0.ebuild,v 1.6 2002/10/04 05:44:55 vapier Exp $
inherit kde-base

DESCRIPTION="Gwenview is an image viewer for KDE"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://gwenview.sourceforge.net/"


LICENSE="GPL-2"
KEYWORDS="x86"

newdepend ">=kde-base/kdebase-3.0"

need-kde 3
