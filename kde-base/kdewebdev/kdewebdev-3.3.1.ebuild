# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdewebdev/kdewebdev-3.3.1.ebuild,v 1.10 2004/12/18 22:35:50 corsair Exp $

inherit kde-dist eutils

DESCRIPTION="KDE web development - Quanta"

KEYWORDS="amd64 ~hppa ppc sparc x86 alpha ppc64"
IUSE="doc"

DEPEND="~kde-base/kdebase-${PV}
	doc? ( app-doc/quanta-docs )"
