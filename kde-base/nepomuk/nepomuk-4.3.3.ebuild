# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/nepomuk/nepomuk-4.3.3.ebuild,v 1.6 2010/01/19 00:58:27 jer Exp $

EAPI="2"

KMNAME="kdebase-runtime"
inherit kde4-meta

DESCRIPTION="Nepomuk KDE4 client"
KEYWORDS="amd64 hppa ppc ppc64 ~sparc x86"
IUSE="debug +handbook"

DEPEND="
	|| (
		>=dev-libs/soprano-2.3.0[clucene,dbus,raptor,java]
		>=dev-libs/soprano-2.3.0[clucene,dbus,raptor,redland]
	)
	$(add_kdebase_dep kdelibs semantic-desktop)
"
# BLOCKS:
# kde-base/akonadi: installed nepomuk ontologies, which were supposed to be here
add_blocker akonadi '<4.2.60'
