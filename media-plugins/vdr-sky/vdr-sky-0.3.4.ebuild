# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-sky/vdr-sky-0.3.4.ebuild,v 1.1 2006/03/21 14:25:35 zzam Exp $

IUSE=""

inherit vdr-plugin

VDR_V=1.3.44

DESCRIPTION="VDR plugin: use kfir mpeg encoder card as input"
HOMEPAGE="http://www.cadsoft.de/vdr/"
SRC_URI="ftp://ftp.cadsoft.de/vdr/Developer/vdr-${VDR_V}.tar.bz2"

KEYWORDS="~x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=media-video/vdr-1.3.36"

S=${WORKDIR}/vdr-${VDR_V}/PLUGINS/src/${VDRPLUGIN}

