# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-xemacs/semantic/semantic-1.17.ebuild,v 1.6 2005/01/01 17:14:32 eradicator Exp $

SLOT="0"
IUSE=""
DESCRIPTION="Semantic bovinator (Yacc/Lex for XEmacs). Includes Senator."
PKG_CAT="standard"

DEPEND="app-xemacs/eieio
app-xemacs/xemacs-base
app-xemacs/xemacs-devel
app-xemacs/edit-utils
app-xemacs/speedbar
app-xemacs/texinfo
app-xemacs/fsf-compat
app-xemacs/cc-mode
app-xemacs/edebug
"
KEYWORDS="x86 ~ppc alpha sparc amd64"

inherit xemacs-packages

