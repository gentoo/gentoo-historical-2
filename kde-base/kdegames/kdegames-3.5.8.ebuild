# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-base/kdegames/kdegames-3.5.8.ebuild,v 1.4 2008/01/29 15:12:59 armin76 Exp $

inherit kde-dist

DESCRIPTION="KDE games (not just solitaire ;-)"

KEYWORDS="alpha amd64 hppa ia64 ~ppc ~ppc64 sparc ~x86"
IUSE="kdehiddenvisibility"

# For backgrounds in kpat.
RDEPEND="~kde-base/kdebase-${PV}"

# Surprise, surprise... Tests are broken.
RESTRICT="test"
