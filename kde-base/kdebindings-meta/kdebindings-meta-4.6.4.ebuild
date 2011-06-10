# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdebindings-meta/kdebindings-meta-4.6.4.ebuild,v 1.1 2011/06/10 17:59:41 dilfridge Exp $

EAPI=4
inherit kde4-meta-pkg

DESCRIPTION="KDE bindings - merge this to pull in all kdebindings-derived packages"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="csharp java perl python ruby"

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
"
