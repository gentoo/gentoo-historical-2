# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-skincurses/vdr-skincurses-0.1.7.ebuild,v 1.1 2008/04/05 22:27:17 hd_brummy Exp $

IUSE=""

inherit vdr-plugin

VDR_V=1.6.0

DESCRIPTION="VDR plugin: show content of menu in a shell window"
HOMEPAGE="http://www.cadsoft.de/vdr/"
SRC_URI="ftp://ftp.cadsoft.de/vdr/Developer/vdr-${VDR_V}.tar.bz2"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=media-video/vdr-1.6.0"

S=${WORKDIR}/vdr-${VDR_V}/PLUGINS/src/${VDRPLUGIN}
