# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/idlwave/idlwave-1.27.ebuild,v 1.6 2004/06/24 23:14:13 agriffis Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Editing and Shell mode for the Interactive Data Language"
PKG_CAT="standard"

DEPEND="app-xemacs/fsf-compat
app-xemacs/xemacs-base
"
KEYWORDS="x86 ~ppc ~alpha sparc"

inherit xemacs-packages

