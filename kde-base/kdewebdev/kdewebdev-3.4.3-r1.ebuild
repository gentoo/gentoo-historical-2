# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdewebdev/kdewebdev-3.4.3-r1.ebuild,v 1.2 2005/12/06 06:12:03 josejx Exp $

inherit kde-dist

DESCRIPTION="KDE web development - Quanta"

KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~mips ppc ~sparc ~x86"
IUSE="doc tidy"

DEPEND="dev-libs/libxslt
	dev-libs/libxml2"

RDEPEND="${DEPEND}
	tidy? ( app-text/htmltidy )
	doc? ( app-doc/quanta-docs )"

PATCHES="${FILESDIR}/kxsldbg-3.4.3-fmt-str.patch"