# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-texlive/texlive-langgerman/texlive-langgerman-2008.ebuild,v 1.6 2009/03/10 19:32:24 armin76 Exp $

TEXLIVE_MODULE_CONTENTS="dehyph-exptl german germbib mkind-german r_und_s uhrzeit umlaute hyphen-german collection-langgerman
"
TEXLIVE_MODULE_DOC_CONTENTS="dehyph-exptl.doc german.doc germbib.doc r_und_s.doc umlaute.doc "
TEXLIVE_MODULE_SRC_CONTENTS="german.source umlaute.source "
inherit texlive-module
DESCRIPTION="TeXLive German"

LICENSE="GPL-2 as-is freedist LPPL-1.3 "
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh sparc x86 ~x86-fbsd"
IUSE=""
DEPEND=">=dev-texlive/texlive-basic-2008
"
RDEPEND="${DEPEND}"
