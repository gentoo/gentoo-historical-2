# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-action/slune/slune-0.5.ebuild,v 1.4 2004/06/02 01:16:41 mr_bones_ Exp $

inherit distutils

DESCRIPTION="A 3D action game with multiplayer mode and amazing graphics"
HOMEPAGE="http://oomadness.nekeme.net/en/slune/"
SRC_URI="http://oomadness.nekeme.net/downloads/Slune-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86"
IUSE=""

DEPEND="virtual/x11
	virtual/opengl
	>=media-libs/libsdl-1.2.6
	>=dev-lang/python-2.2.2
	>=dev-python/soya-0.5
	>=dev-python/py2play-0.1.5
	>=dev-python/pyopenal-0.1.2
	>=dev-python/editobj-0.5.2"

S="${WORKDIR}/Slune-${PV}"
