# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/gwenview/gwenview-1.0.1.ebuild,v 1.6 2005/01/10 17:35:17 lanius Exp $

inherit kde

DESCRIPTION="image viewer for KDE"
HOMEPAGE="http://gwenview.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="x86 ~amd64"
IUSE=""

need-kde 3
