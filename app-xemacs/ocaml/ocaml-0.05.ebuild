# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/ocaml/ocaml-0.05.ebuild,v 1.1 2006/11/12 11:05:11 graaff Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Objective Caml editing support."
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/fsf-compat
"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

inherit xemacs-packages

