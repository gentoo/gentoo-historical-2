# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/footnote/footnote-1.15.ebuild,v 1.9 2005/01/01 17:04:07 eradicator Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Footnoting in mail message editing modes."
PKG_CAT="standard"

DEPEND="app-xemacs/mail-lib
app-xemacs/xemacs-base
"
KEYWORDS="x86 ~ppc alpha sparc amd64"

inherit xemacs-packages
