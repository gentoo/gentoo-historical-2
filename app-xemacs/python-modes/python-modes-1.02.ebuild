# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/python-modes/python-modes-1.02.ebuild,v 1.8 2007/07/11 02:37:37 mr_bones_ Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Python support."
PKG_CAT="standard"

DEPEND="app-xemacs/xemacs-base
app-xemacs/mail-lib
"
KEYWORDS="alpha amd64 ppc sparc x86"

inherit xemacs-packages
