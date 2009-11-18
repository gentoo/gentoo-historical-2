# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/htmlize/htmlize-1.36.ebuild,v 1.2 2009/11/18 19:10:13 fauli Exp $

inherit elisp

DESCRIPTION="HTML-ize font-lock buffers in Emacs"
HOMEPAGE="http://www.emacswiki.org/cgi-bin/wiki.pl?SaveAsHtml
	http://fly.srk.fer.hr/~hniksic/emacs/"
SRC_URI="mirror://gentoo/${P}.el.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc x86"
IUSE=""

SITEFILE="50${PN}-gentoo.el"
