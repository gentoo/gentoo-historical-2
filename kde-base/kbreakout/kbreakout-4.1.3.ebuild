# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kbreakout/kbreakout-4.1.3.ebuild,v 1.2 2008/11/16 04:45:46 vapier Exp $

EAPI="2"

KMNAME=kdegames

inherit kde4-meta

DESCRIPTION="KDE: A Breakout-like game for KDE."
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="debug htmlhandbook"

KMLOADLIBS="libkdegames"

