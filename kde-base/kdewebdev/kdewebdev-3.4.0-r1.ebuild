# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdewebdev/kdewebdev-3.4.0-r1.ebuild,v 1.1 2005/04/20 00:02:13 carlo Exp $

inherit kde-dist eutils

DESCRIPTION="KDE web development - Quanta"

KEYWORDS="~x86 ~amd64 ~sparc ~ppc"
IUSE="doc tidy"

DEPEND="~kde-base/kdebase-${PV}
	doc? ( app-doc/quanta-docs )"

RDEPEND="${DEPEND}
	tidy? ( app-text/htmltidy )"

src_unpack(){
	kde_src_unpack
	epatch ${FILESDIR}/post-3.4-kdewebdev.diff
}