# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/locale/locale-1.20.ebuild,v 1.1.1.1 2005/11/30 09:38:52 chriswhite Exp $

SLOT="0"
IUSE=""
DESCRIPTION="MULE: Localized menubars and localized splash screens."
PKG_CAT="mule"

DEPEND="app-xemacs/mule-base
"
KEYWORDS="x86 ~ppc alpha sparc amd64"

inherit xemacs-packages

