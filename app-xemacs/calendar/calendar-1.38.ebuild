# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/calendar/calendar-1.38.ebuild,v 1.1 2009/02/22 14:52:01 graaff Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Calendar and diary support."
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

inherit xemacs-packages
