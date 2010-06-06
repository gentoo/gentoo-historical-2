# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebindings-meta/kdebindings-meta-4.4.4.ebuild,v 1.1 2010/06/06 14:41:26 scarabeus Exp $

EAPI="3"
inherit kde4-functions

DESCRIPTION="KDE bindings - merge this to pull in all kdebindings-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.4"
KEYWORDS="~amd64 ~x86"
IUSE="aqua csharp java kdeprefix python ruby"

RDEPEND="
	$(add_kdebase_dep smoke)
	csharp? ( $(add_kdebase_dep kdebindings-csharp) )
	java? ( $(add_kdebase_dep krossjava) )
	python? (
		$(add_kdebase_dep krosspython)
		$(add_kdebase_dep pykde4)
	)
	ruby? (
		$(add_kdebase_dep kdebindings-ruby)
		$(add_kdebase_dep krossruby)
	)
	$(block_other_slots)
"
