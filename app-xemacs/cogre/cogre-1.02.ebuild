# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/cogre/cogre-1.02.ebuild,v 1.2 2010/09/18 18:01:54 armin76 Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Graph editing mode."
PKG_CAT="standard"

RDEPEND="
app-xemacs/xemacs-base
app-xemacs/xemacs-devel
app-xemacs/edebug
app-xemacs/cedet-common
app-xemacs/eieio
app-xemacs/semantic
"
KEYWORDS="~alpha ~amd64 ~sparc ~x86"

inherit xemacs-packages
