# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/pgg/pgg-1.06.ebuild,v 1.2 2006/11/12 18:32:23 graaff Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Emacs interface to various PGP implementations."
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/fsf-compat
app-xemacs/edebug
app-xemacs/ecrypto
"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

inherit xemacs-packages

