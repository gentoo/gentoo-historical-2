# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/haskell-mode/haskell-mode-1.10.ebuild,v 1.3 2007/06/03 18:32:20 graaff Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Haskell editing support."
PKG_CAT="standard"

RDEPEND="app-xemacs/dired
app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/edit-utils
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages

