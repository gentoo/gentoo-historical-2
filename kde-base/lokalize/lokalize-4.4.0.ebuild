# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/lokalize/lokalize-4.4.0.ebuild,v 1.1 2010/02/09 00:16:25 alexxy Exp $

EAPI="2"

KMNAME="kdesdk"
inherit kde4-meta

DESCRIPTION="KDE4 translation tool"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug +handbook"

# Althrought they are purely runtime, its too useless without them
DEPEND="
	>=app-text/hunspell-1.2.8
	>=x11-libs/qt-sql-4.5.0:4[sqlite]
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep kdesdk-strigi-analyzer)
	$(add_kdebase_dep krosspython)
	$(add_kdebase_dep pykde4)
"

pkg_postinst() {
	echo
	elog "To be able to autofetch KDE translations in new project wizard, install subversion client:"
	elog "	emerge -vau subversion"
	echo
}
