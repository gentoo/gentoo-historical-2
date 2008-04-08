# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-mathextra/texlive-mathextra-2007.ebuild,v 1.13 2008/04/08 14:59:23 armin76 Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-fontsrecommended
dev-texlive/texlive-latex
"
TEXLIVE_MODULE_CONTENTS="12many amstex bin-amstex breqn ccfonts commath concmath concrete eqnarray extarrows extpfeil faktor hvmath mathcomp mh mhequ nath stmaryrd tensor tmmath venn xfrac yhmath collection-mathextra
"
inherit texlive-module
DESCRIPTION="TeXLive Advanced math typesetting"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="alpha ~amd64 hppa ia64 ~ppc ppc64 sparc x86 ~x86-fbsd"
