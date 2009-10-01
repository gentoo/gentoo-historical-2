# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-fps/quake3-urbanterror/quake3-urbanterror-4.1.ebuild,v 1.2 2009/10/01 21:49:38 nyhm Exp $

MOD_DESC="total transformation realism based MOD"
MOD_NAME="Urban Terror"
MOD_DIR="q3ut4"
MOD_BINS="ut4"

# Since this is easily done, we'll slot it so clans can easily play on older
# versions of the mod without having to mask anything.
SLOT=4

inherit games games-mods

HOMEPAGE="http://www.urbanterror.net/"
SRC_URI="ftp://ftp.snt.utwente.nl/pub/games/urbanterror/UrbanTerror_41_FULL.zip"

LICENSE="freedist"
SLOT="3"
KEYWORDS="-* ~amd64 ~ppc ~x86"
IUSE="dedicated opengl"
RESTRICT="mirror strip"
