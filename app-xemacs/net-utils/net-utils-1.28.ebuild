# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/net-utils/net-utils-1.28.ebuild,v 1.6 2004/06/24 23:17:19 agriffis Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Miscellaneous Networking Utilities."
PKG_CAT="standard"

DEPEND="app-xemacs/w3
app-xemacs/efs
app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/fsf-compat
app-xemacs/eterm
app-xemacs/sh-script
"
KEYWORDS="x86 ~ppc ~alpha sparc"

inherit xemacs-packages

