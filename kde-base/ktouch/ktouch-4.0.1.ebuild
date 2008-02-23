# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/ktouch/ktouch-4.0.1.ebuild,v 1.2 2008/02/23 17:43:47 ingmar Exp $

EAPI="1"

KMNAME=kdeedu
inherit kde4-meta

DESCRIPTION="KDE: A program that helps you to learn and practice touch typing"
KEYWORDS="~amd64 ~x86"
IUSE="debug htmlhandbook"

RDEPEND=">=kde-base/knotify-${PV}:${SLOT}"
