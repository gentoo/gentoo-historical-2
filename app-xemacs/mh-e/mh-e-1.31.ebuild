# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/mh-e/mh-e-1.31.ebuild,v 1.1 2009/02/22 10:09:15 graaff Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Front end support for MH."
PKG_CAT="standard"

RDEPEND="app-xemacs/gnus
app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/speedbar
app-xemacs/rmail
app-xemacs/tm
app-xemacs/apel
app-xemacs/sh-script
app-xemacs/fsf-compat
app-xemacs/xemacs-devel
app-xemacs/net-utils
app-xemacs/xemacs-eterm
app-xemacs/os-utils
app-xemacs/ecrypto
"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

inherit xemacs-packages
