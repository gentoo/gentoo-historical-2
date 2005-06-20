# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/kzenexplorer/kzenexplorer-0.6_rc1.ebuild,v 1.1 2005/06/20 21:51:18 vanquirius Exp $

inherit kde eutils
need-kde 3.3

DESCRIPTION="A QT frontend for libnjb and its supported players."
HOMEPAGE="http://kzenexplorer.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="${DEPEND}
	>=media-libs/libnjb-2.0
	>=media-libs/taglib-1.3"
