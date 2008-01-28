# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-clock/vdr-clock-0.0.10.ebuild,v 1.1 2008/01/28 15:55:18 zzam Exp $

inherit vdr-plugin

DESCRIPTION="Video Disk Recorder Clock PlugIn"
HOMEPAGE="http://vdr.humpen.at"
SRC_URI="http://vdr.humpen.at/uploads/media/${P}.tgz
		mirror://vdrfiles/${PN}/${P}.tgz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=media-video/vdr-1.2.0"

#PATCHES="${FILESDIR}/${PV}/pingpong-fixes.diff"
