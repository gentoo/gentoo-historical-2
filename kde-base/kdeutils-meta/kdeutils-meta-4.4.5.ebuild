# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeutils-meta/kdeutils-meta-4.4.5.ebuild,v 1.1 2010/06/30 15:36:38 alexxy Exp $

EAPI="3"
inherit kde4-functions

DESCRIPTION="kdeutils - merge this to pull in all kdeutils-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.4"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="aqua cups floppy kdeprefix lirc"

RDEPEND="
	$(add_kdebase_dep ark)
	$(add_kdebase_dep kcalc)
	$(add_kdebase_dep kcharselect)
	$(add_kdebase_dep kdf)
	$(add_kdebase_dep kgpg)
	$(add_kdebase_dep ktimer)
	$(add_kdebase_dep kwallet)
	$(add_kdebase_dep superkaramba)
	$(add_kdebase_dep sweeper)
	$(add_kdebase_dep okteta)
	cups? ( $(add_kdebase_dep printer-applet) )
	floppy? ( $(add_kdebase_dep kfloppy) )
	lirc? ( $(add_kdebase_dep kdelirc) )
	$(block_other_slots)
"
