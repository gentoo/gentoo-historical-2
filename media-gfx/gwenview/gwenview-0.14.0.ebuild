# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gwenview/gwenview-0.14.0.ebuild,v 1.1 2002/06/18 20:04:40 danarmak Exp $
inherit kde-base

DESCRIPTION="Gwenview is an image viewer for KDE"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
HOMEPAGE="http://gwenview.sourceforge.net/"

newdepend ">=kde-base/kdebase-3.0"

need-kde 3

