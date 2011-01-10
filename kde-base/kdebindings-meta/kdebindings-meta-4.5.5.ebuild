# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebindings-meta/kdebindings-meta-4.5.5.ebuild,v 1.1 2011/01/10 11:53:27 tampakrap Exp $

EAPI="3"
inherit kde4-functions

DESCRIPTION="KDE bindings - merge this to pull in all kdebindings-derived packages"
HOMEPAGE="http://www.kde.org/"

LICENSE="GPL-2"
SLOT="4.5"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="aqua csharp java kdeprefix perl python ruby"

RDEPEND="
	$(add_kdebase_dep smoke)
	csharp? ( $(add_kdebase_dep kdebindings-csharp) )
	java? ( $(add_kdebase_dep krossjava) )
	perl? ( $(add_kdebase_dep kdebindings-perl) )
	python? (
		$(add_kdebase_dep krosspython)
		$(add_kdebase_dep pykde4)
	)
	ruby? ( $(add_kdebase_dep kdebindings-ruby) )
	$(block_other_slots)
"
