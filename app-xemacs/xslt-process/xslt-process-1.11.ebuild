# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/xslt-process/xslt-process-1.11.ebuild,v 1.3 2003/02/13 10:01:11 vapier Exp $

SLOT="0"
IUSE=""
DESCRIPTION="XSLT processing support."
PKG_CAT="standard"

DEPEND="app-xemacs/jde
app-xemacs/cc-mode
app-xemacs/semantic
app-xemacs/debug
app-xemacs/speedbar
app-xemacs/edit-utils
app-xemacs/eterm
app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/elib
app-xemacs/eieio
app-xemacs/sh-script
app-xemacs/fsf-compat
app-xemacs/xemacs-devel
"
KEYWORDS="x86 -ppc alpha sparc"

inherit xemacs-packages

