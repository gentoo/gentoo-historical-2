# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/clearcase/clearcase-1.04.ebuild,v 1.5 2003/10/03 02:18:29 agriffis Exp $

SLOT="0"
IUSE=""
DESCRIPTION="New Clearcase Version Control for XEmacs (UNIX, Windows)."
PKG_CAT="standard"

DEPEND="app-xemacs/dired
app-xemacs/fsf-compat
app-xemacs/mail-lib
app-xemacs/xemacs-base
"
KEYWORDS="x86 ~ppc alpha sparc"

inherit xemacs-packages

