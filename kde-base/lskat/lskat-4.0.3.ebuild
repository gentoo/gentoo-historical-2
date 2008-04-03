# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/lskat/lskat-4.0.3.ebuild,v 1.1 2008/04/03 21:43:58 philantrop Exp $

EAPI="1"

KMNAME=kdegames
inherit kde4-meta

DESCRIPTION="Skat game for KDE"
KEYWORDS="~amd64 ~x86"
IUSE="debug "

PATCHES="${FILESDIR}/${PN}-4.0.0-link.patch"
