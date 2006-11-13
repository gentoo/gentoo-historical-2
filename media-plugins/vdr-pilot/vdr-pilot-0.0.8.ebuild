# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-pilot/vdr-pilot-0.0.8.ebuild,v 1.2 2006/11/13 09:45:56 zzam Exp $

IUSE=""
inherit vdr-plugin eutils

DESCRIPTION="VDR plugin: Another way for viewing EPG and zap to channels"
HOMEPAGE="http://famillejacques.free.fr/vdr/"
SRC_URI="http://famillejacques.free.fr/vdr/pilot/${P}.tgz"

KEYWORDS="x86"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=media-video/vdr-1.3.8"

PATCHES="${FILESDIR}/${P}-includes.diff"
