# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/showimg/showimg-0.9.3.ebuild,v 1.1 2004/07/06 21:55:16 centic Exp $

inherit kde

DESCRIPTION="feature-rich image viewer for KDE"
SRC_URI="http://www.jalix.org/projects/showimg/download/${PVR}/${P}.tar.gz"
HOMEPAGE="http://www.jalix.org/projects/showimg/"

LICENSE="GPL-2"
KEYWORDS="~x86"

IUSE=""
SLOT="0"

need-kde 3.1

