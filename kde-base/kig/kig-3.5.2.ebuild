# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kig/kig-3.5.2.ebuild,v 1.5 2006/05/26 17:15:06 wolf31o2 Exp $
KMNAME=kdeedu
MAXKDEVER=$PV
KM_DEPRANGE="$PV $MAXKDEVER"
inherit kde-meta

DESCRIPTION="KDE Interactive Geometry tool"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ppc64 ~sparc x86"
IUSE="kig-scripting"
DEPEND="kig-scripting? ( >=dev-libs/boost-1.32 )"

src_compile() {
	myconf="${myconf} $(use_enable kig-scripting kig-python-scripting)"

	kde_src_compile
}
