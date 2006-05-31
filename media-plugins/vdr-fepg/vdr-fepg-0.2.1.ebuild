# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-fepg/vdr-fepg-0.2.1.ebuild,v 1.2 2006/05/31 15:46:31 zzam Exp $

inherit vdr-plugin

DESCRIPTION="VDR plugin: show epg of multiple channels graphically"
HOMEPAGE="http://www.fepg.tk/"
SRC_URI="http://fepg2.f2g.net/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.3.36"

