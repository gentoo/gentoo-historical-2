# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/supercite/supercite-1.19.ebuild,v 1.10 2005/01/01 17:16:57 eradicator Exp $

SLOT="0"
IUSE=""
DESCRIPTION="An Emacs citation tool for News & Mail messages."
PKG_CAT="standard"

DEPEND="app-xemacs/mail-lib
app-xemacs/xemacs-base
"
KEYWORDS="amd64 x86 ~ppc alpha sparc ppc64"

inherit xemacs-packages

