# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/edit-utils/edit-utils-2.36.ebuild,v 1.2 2007/05/29 18:29:55 armin76 Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Miscellaneous editor extensions, you probably need this."
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/xemacs-devel
app-xemacs/fsf-compat
app-xemacs/dired
app-xemacs/mail-lib
"
KEYWORDS="alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

inherit xemacs-packages
