# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/xemacs-eterm/xemacs-eterm-1.17.ebuild,v 1.2 2006/11/14 12:36:42 graaff Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Terminal emulation."
PKG_CAT="standard"

MY_PN=${PN/xemacs-/}
SRC_URI="http://ftp.xemacs.org/packages/${MY_PN}-${PV}-pkg.tar.gz"

RDEPEND="app-xemacs/xemacs-base"

KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

inherit xemacs-packages
