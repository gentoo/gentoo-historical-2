# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/igrep/igrep-1.10.ebuild,v 1.3 2003/02/13 09:54:09 vapier Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Enhanced front-end for Grep."
PKG_CAT="standard"

DEPEND="app-xemacs/dired
app-xemacs/xemacs-base
app-xemacs/efs
"
KEYWORDS="x86 -ppc alpha sparc"

inherit xemacs-packages

