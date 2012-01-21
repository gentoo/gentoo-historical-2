# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/vdr-dvd/vdr-dvd-0.3.7_pre20090106.ebuild,v 1.3 2012/01/21 18:05:26 ssuominen Exp $

EAPI=3

inherit vdr-plugin

MY_P=${PN}-cvs-${PV#*_pre}
S=${WORKDIR}/${MY_P#vdr-}

DESCRIPTION="VDR Plugin: DVD-Player"
HOMEPAGE="http://sourceforge.net/projects/dvdplugin"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=media-video/vdr-1.6.0
	>=media-libs/libdvdnav-4.2.0
	>=media-libs/a52dec-0.7.4"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-compile_warnings.diff
	"${FILESDIR}"/${P}-fix-dvdnav-using-c++-keywords.patch
	)
