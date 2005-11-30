# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/efs/efs-1.29.ebuild,v 1.1.1.1 2005/11/30 09:38:51 chriswhite Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Treat files on remote systems the same as local files."
PKG_CAT="standard"

DEPEND="app-xemacs/xemacs-base
app-xemacs/dired
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
