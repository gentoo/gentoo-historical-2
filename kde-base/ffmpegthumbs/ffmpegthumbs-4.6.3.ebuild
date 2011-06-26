# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ffmpegthumbs/ffmpegthumbs-4.6.3.ebuild,v 1.4 2011/06/26 01:54:46 ranger Exp $

EAPI=4

KMNAME="kdemultimedia"
inherit kde4-meta

DESCRIPTION="A FFmpeg based thumbnail Generator for Video Files."
KEYWORDS="amd64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	virtual/ffmpeg
"
RDEPEND="${DEPEND}"
