# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/calc/calc-1.23.ebuild,v 1.1.1.1 2005/11/30 09:38:51 chriswhite Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Emacs calculator"
PKG_CAT="standard"

DEPEND="app-xemacs/xemacs-base
"
KEYWORDS="x86 ppc alpha sparc amd64 ppc64"

inherit xemacs-packages
