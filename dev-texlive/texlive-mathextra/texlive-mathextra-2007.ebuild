# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-mathextra/texlive-mathextra-2007.ebuild,v 1.3 2007/10/25 12:45:49 fmccor Exp $

TEXLIVE_MODULES_DEPS="dev-texlive/texlive-fontsrecommended
dev-texlive/texlive-latex
"
TEXLIVE_MODULE_CONTENTS="12many amstex bin-amstex breqn ccfonts commath concmath concrete eqnarray extarrows extpfeil faktor hvmath mathcomp mh mhequ nath stmaryrd tensor tmmath venn xfrac yhmath collection-mathextra
"
inherit texlive-module
DESCRIPTION="TeXLive Advanced math typesetting"

LICENSE="GPL-2 LPPL-1.3c"
SLOT="0"
KEYWORDS="~sparc ~x86"
