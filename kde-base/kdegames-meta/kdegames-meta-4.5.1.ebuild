# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdegames-meta/kdegames-meta-4.5.1.ebuild,v 1.1 2010/09/06 00:03:25 tampakrap Exp $

EAPI="3"
inherit kde4-functions

DESCRIPTION="kdegames - merge this to pull in all kdegames-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.5"
KEYWORDS=""
IUSE="aqua kdeprefix opengl python"

RDEPEND="
	$(add_kdebase_dep bomber)
	$(add_kdebase_dep bovo)
	$(add_kdebase_dep granatier)
	$(add_kdebase_dep kapman)
	$(add_kdebase_dep katomic)
	$(add_kdebase_dep kbattleship)
	$(add_kdebase_dep kblackbox)
	$(add_kdebase_dep kblocks)
	$(add_kdebase_dep kbounce)
	$(add_kdebase_dep kbreakout)
	$(add_kdebase_dep kdiamond)
	$(add_kdebase_dep kfourinline)
	$(add_kdebase_dep kgoldrunner)
	$(add_kdebase_dep killbots)
	$(add_kdebase_dep kigo)
	$(add_kdebase_dep kiriki)
	$(add_kdebase_dep kjumpingcube)
	$(add_kdebase_dep klines)
	$(add_kdebase_dep kmahjongg)
	$(add_kdebase_dep kmines)
	$(add_kdebase_dep knetwalk)
	$(add_kdebase_dep kolf)
	$(add_kdebase_dep kollision)
	$(add_kdebase_dep konquest)
	$(add_kdebase_dep kpat)
	$(add_kdebase_dep kreversi)
	$(add_kdebase_dep ksame)
	$(add_kdebase_dep kshisen)
	$(add_kdebase_dep ksirk)
	$(add_kdebase_dep kspaceduel)
	$(add_kdebase_dep ksquares)
	$(add_kdebase_dep ktron)
	$(add_kdebase_dep ktuberling)
	$(add_kdebase_dep kubrick)
	$(add_kdebase_dep libkdegames)
	$(add_kdebase_dep libkmahjongg)
	$(add_kdebase_dep lskat)
	$(add_kdebase_dep palapeli)
	opengl? ( $(add_kdebase_dep ksudoku) )
	python? ( $(add_kdebase_dep kajongg) )
	$(block_other_slots)
"
