# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-tv/kvdr/kvdr-0.64.ebuild,v 1.1 2006/07/28 20:09:55 zzam Exp $

inherit kde

DESCRIPTION="A KDE GUI for VDR (Video Disk Recorder)."
HOMEPAGE="http://www.s.netic.de/gfiala/"
#SRC_URI="http://www.s.netic.de/gfiala/${P}.tgz"
SRC_URI="mirror://gentoo/${P}-gentoo.tar.gz
	http://dev.gentoo.org/~zzam/distfiles/${P}-gentoo.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND=">=media-tv/xawtv-3.86
	media-tv/linuxtv-dvb-headers
	>=media-video/vdr-1.2.0"

need-kde 3

S=${WORKDIR}/${P}-gentoo

