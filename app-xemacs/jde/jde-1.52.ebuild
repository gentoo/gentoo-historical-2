# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/jde/jde-1.52.ebuild,v 1.1 2010/02/10 21:21:33 graaff Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Integrated Development Environment for Java."
PKG_CAT="standard"

RDEPEND="app-xemacs/cc-mode
app-xemacs/semantic
app-xemacs/debug
app-xemacs/speedbar
app-xemacs/edit-utils
app-xemacs/xemacs-eterm
app-xemacs/mail-lib
app-xemacs/xemacs-base
app-xemacs/xemacs-devel
app-xemacs/cedet-common
app-xemacs/eieio
app-xemacs/elib
app-xemacs/sh-script
app-xemacs/fsf-compat
app-xemacs/os-utils
"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86"

inherit xemacs-packages
