# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/tramp/tramp-1.11.ebuild,v 1.2 2003/10/03 02:44:10 agriffis Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Remote shell-based file editing."
PKG_CAT="standard"

DEPEND="app-xemacs/xemacs-base
app-xemacs/vc
app-xemacs/fsf-compat
app-xemacs/efs
app-xemacs/dired
app-xemacs/mail-lib
app-xemacs/gnus
app-xemacs/ediff
"
KEYWORDS="x86 ~ppc alpha sparc"

inherit xemacs-packages

