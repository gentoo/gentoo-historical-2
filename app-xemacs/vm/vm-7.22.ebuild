# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/vm/vm-7.22.ebuild,v 1.1 2006/11/12 14:42:49 graaff Exp $

SLOT="0"
IUSE=""
DESCRIPTION="An Emacs mailer."
PKG_CAT="standard"

RDEPEND="app-xemacs/mail-lib
app-xemacs/xemacs-base
"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

inherit xemacs-packages

