# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kplayer/kplayer-0.5.3.ebuild,v 1.1.1.1 2005/11/30 09:57:22 chriswhite Exp $

inherit kde

DESCRIPTION="KPlayer is a KDE media player based on mplayer."
HOMEPAGE="http://www.sourceforge.net/projects/kplayer"
SRC_URI="mirror://sourceforge/kplayer/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="x86 ~ppc ~amd64"
IUSE=""

DEPEND="media-video/mplayer"
need-kde 3.1