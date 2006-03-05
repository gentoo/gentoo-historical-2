# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-cdda/vdr-cdda-0.1.0.ebuild,v 1.2 2006/03/05 11:30:14 zzam Exp $

IUSE=""

inherit vdr-plugin

DESCRIPTION="Video Disk Recorder - CD Digital Audio"
HOMEPAGE="http://www.wahnadium.org/plugins"
SRC_URI="ftp://ftp.wahnadium.org/pub/vdr-cdda/${P}.tar.gz
	mirror://vdrfiles/${PN}/${VDRPLUGIN}-${PV}.patch"

KEYWORDS="~x86 ~amd64"
SLOT="0"
LICENSE="GPL-2"

DEPEND=">=media-video/vdr-1.3.22
	>=dev-libs/libcdio-0.75
	"

PATCHES="${DISTDIR}/${VDRPLUGIN}-${PV}.patch"

