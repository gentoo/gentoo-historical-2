# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-pda/ipodslave/ipodslave-0.7.3.ebuild,v 1.1 2006/05/07 16:16:32 jhuebel Exp $

inherit kde eutils

IUSE=""
DESCRIPTION="KDE ioslave for managing the Apple iPod"
HOMEPAGE="http://kpod.sourceforge.net/ipodslave/"
SRC_URI="mirror://sourceforge/kpod/${P}.tar.bz2"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"

DEPEND="media-libs/id3lib"

need-kde 3.2
