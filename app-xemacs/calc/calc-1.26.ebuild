# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/calc/calc-1.26.ebuild,v 1.1 2006/11/11 13:27:06 graaff Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Emacs calculator"
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

inherit xemacs-packages
