# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/idlwave/idlwave-1.32.ebuild,v 1.1 2006/11/12 08:56:27 graaff Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Editing and Shell mode for the Interactive Data Language"
PKG_CAT="standard"

RDEPEND="app-xemacs/fsf-compat
app-xemacs/xemacs-base
app-xemacs/mail-lib
"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

inherit xemacs-packages

