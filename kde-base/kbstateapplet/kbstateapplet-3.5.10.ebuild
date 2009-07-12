# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kbstateapplet/kbstateapplet-3.5.10.ebuild,v 1.6 2009/07/12 13:14:08 armin76 Exp $
KMNAME=kdeaccessibility
EAPI="1"
inherit kde-meta

DESCRIPTION="KDE panel applet that displays the keyboard status"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""
DEPEND="|| ( >=kde-base/kcontrol-${PV}:${SLOT} >=kde-base/kdebase-${PV}:${SLOT} )"

RDEPEND="${DEPEND}"
