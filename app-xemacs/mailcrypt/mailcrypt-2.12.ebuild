# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/mailcrypt/mailcrypt-2.12.ebuild,v 1.10 2005/01/01 17:08:37 eradicator Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Support for messaging encryption with PGP."
PKG_CAT="standard"

DEPEND="app-xemacs/mail-lib
app-xemacs/fsf-compat
app-xemacs/xemacs-base
app-xemacs/cookie
app-xemacs/gnus
app-xemacs/mh-e
app-xemacs/rmail
app-xemacs/vm
"
KEYWORDS="amd64 x86 ~ppc alpha sparc ppc64"

inherit xemacs-packages

