# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdewebdev/kdewebdev-3.4.1-r1.ebuild,v 1.2 2005/12/10 17:50:50 yoswink Exp $

inherit kde-dist flag-o-matic

DESCRIPTION="KDE web development - Quanta"

KEYWORDS="alpha ~amd64 ~hppa ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE="doc tidy"

DEPEND="~kde-base/kdebase-${PV}"

RDEPEND="${DEPEND}
	tidy? ( app-text/htmltidy )
	doc? ( app-doc/quanta-docs )"

PATCHES="${FILESDIR}/kxsldbg-3.4.3-fmt-str.patch"