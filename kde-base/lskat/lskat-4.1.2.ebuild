# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/lskat/lskat-4.1.2.ebuild,v 1.2 2008/12/31 03:29:11 mr_bones_ Exp $

EAPI="2"

KMNAME=kdegames
inherit kde4-meta

DESCRIPTION="Skat game for KDE"
KEYWORDS="~amd64 ~x86"
IUSE="debug "

PATCHES=( "${FILESDIR}/${PN}-4.0.0-link.patch" )
