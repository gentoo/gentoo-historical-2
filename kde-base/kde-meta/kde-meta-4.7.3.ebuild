# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kde-meta/kde-meta-4.7.3.ebuild,v 1.1 2011/11/02 20:48:16 alexxy Exp $

EAPI=4
inherit kde4-meta-pkg

DESCRIPTION="KDE - merge this to pull in all split kde-base/* packages"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="accessibility nls sdk semantic-desktop"

RDEPEND="
	$(add_kdebase_dep kate)
	$(add_kdebase_dep kdeadmin-meta)
	$(add_kdebase_dep kdeartwork-meta)
	$(add_kdebase_dep kdebase-meta)
	$(add_kdebase_dep kdeedu-meta)
	$(add_kdebase_dep kdegames-meta)
	$(add_kdebase_dep kdegraphics-meta)
	$(add_kdebase_dep kdemultimedia-meta)
	$(add_kdebase_dep kdenetwork-meta)
	$(add_kdebase_dep kdeplasma-addons)
	$(add_kdebase_dep kdetoys-meta)
	$(add_kdebase_dep kdeutils-meta)
	accessibility? ( $(add_kdebase_dep kdeaccessibility-meta) )
	nls? ( $(add_kdebase_dep kde-l10n) )
	sdk? (
		$(add_kdebase_dep kdebindings-meta)
		$(add_kdebase_dep kdesdk-meta)
		$(add_kdebase_dep kdewebdev-meta)
	)
	semantic-desktop? (
		$(add_kdebase_dep kdepim-meta "" 4.4.11.1)
	)
"
