# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/calc/calc-1.23.ebuild,v 1.10 2004/12/16 09:51:23 corsair Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Emacs calculator"
PKG_CAT="standard"

DEPEND="app-xemacs/xemacs-base
"
KEYWORDS="x86 ~ppc alpha sparc amd64 ppc64"

inherit xemacs-packages
