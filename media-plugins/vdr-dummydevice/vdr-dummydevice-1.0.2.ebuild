# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-dummydevice/vdr-dummydevice-1.0.2.ebuild,v 1.1 2008/10/19 18:09:27 hd_brummy Exp $

inherit vdr-plugin

DESCRIPTION="VDR plugin: dummy output device - for recording server without TV"
HOMEPAGE="http://phivdr.dyndns.org/vdr/${PN}/"
SRC_URI="http://phivdr.dyndns.org/vdr/${PN}/${P}.tgz"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.2.0"
