# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/ocaml/ocaml-0.06.ebuild,v 1.3 2007/06/03 18:55:06 graaff Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Objective Caml editing support."
PKG_CAT="standard"

RDEPEND="app-xemacs/xemacs-base
app-xemacs/fsf-compat
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages

