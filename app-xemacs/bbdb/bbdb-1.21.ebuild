# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/bbdb/bbdb-1.21.ebuild,v 1.10 2005/01/01 16:57:49 eradicator Exp $

SLOT="0"
IUSE=""
DESCRIPTION="The Big Brother Data Base"
PKG_CAT="standard"

DEPEND="app-xemacs/edit-utils
app-xemacs/gnus
app-xemacs/mh-e
app-xemacs/rmail
app-xemacs/supercite
app-xemacs/vm
app-xemacs/tm
app-xemacs/apel
app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/w3
"
KEYWORDS="amd64 x86 ~ppc alpha sparc ppc64"

inherit xemacs-packages
