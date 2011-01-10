# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/libplasmagenericshell/libplasmagenericshell-4.5.5.ebuild,v 1.1 2011/01/10 11:53:46 tampakrap Exp $

EAPI="3"

KMNAME="kdebase-workspace"
KMMODULE="libs/plasmagenericshell"
inherit kde4-meta

DESCRIPTION="Libraries for the KDE Plasma shell"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug test"

RDEPEND="
	$(add_kdebase_dep libkworkspace)
"

KMSAVELIBS="true"

src_unpack() {
	use test && KMEXTRACTONLY="plasma/desktop/shell/data"
	kde4-meta_src_unpack
}
