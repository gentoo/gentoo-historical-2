# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/liece/liece-1.10.ebuild,v 1.3 2003/02/13 09:54:44 vapier Exp $

SLOT="0"
IUSE=""
DESCRIPTION="IRC (Internet Relay Chat) client for Emacs."
PKG_CAT="standard"

DEPEND="app-xemacs/apel
app-xemacs/mail-lib
app-xemacs/fsf-compat
app-xemacs/xemacs-base
"
KEYWORDS="x86 -ppc alpha sparc"

inherit xemacs-packages

