# Copyright 2003-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-remote/vdr-remote-0.3.8.ebuild,v 1.3 2006/11/18 09:15:15 zzam Exp $

inherit vdr-plugin eutils

DESCRIPTION="VDR Plugin: use various devices for controlling vdr (keyboards, lirc, remotes bundled with tv-cards)"
HOMEPAGE="http://www.escape-edv.de/endriss/vdr/"
SRC_URI="http://www.escape-edv.de/endriss/vdr/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 x86"
IUSE=""

DEPEND=">=media-video/vdr-1.2.6"

