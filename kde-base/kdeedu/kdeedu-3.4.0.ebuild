# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdeedu/kdeedu-3.4.0.ebuild,v 1.1 2005/03/14 21:50:16 greg_g Exp $

inherit kde-dist

DESCRIPTION="KDE educational apps"

KEYWORDS="~x86 ~amd64 ~sparc"
IUSE="python"

DEPEND="python? ( >=dev-libs/boost-1.32 )"

src_compile() {
	myconf="$(use_enable python kig-python-scripting)"

	kde_src_compile
}
