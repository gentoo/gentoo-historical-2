# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/locale/locale-1.20.ebuild,v 1.8 2004/06/24 23:15:26 agriffis Exp $

SLOT="0"
IUSE=""
DESCRIPTION="MULE: Localized menubars and localized splash screens."
PKG_CAT="mule"

DEPEND="app-xemacs/mule-base
"
KEYWORDS="x86 ~ppc alpha sparc amd64"

inherit xemacs-packages

