# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/zoomwin/zoomwin-15.ebuild,v 1.1 2003/12/19 19:48:21 ciaranm Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: brief-style window zooming"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=508"
LICENSE="vim"
KEYWORDS="~alpha ~sparc ~x86 ~ppc"

function src_unpack() {
	unpack ${A}
	mkdir ${S}/doc || die "can't make doc dir"

	# This plugin uses an 'automatic HelpExtractor' variant. This causes
	# problems for us during the unmerge. Fortunately, sed can fix this
	# for us. We'll also fix the broken version number in the help doc.
	sed -e '1,/^" HelpExtractorDoc:$/d' \
		-e "s/^Version: 13/Version: ${PV}/" \
		${S}/plugin/ZoomWin.vim > ${S}/doc/ZoomWin.txt \
		|| die "help extraction failed"
	sed -i -e '/^" HelpExtractor:$/,$d' ${S}/plugin/ZoomWin.vim \
		|| die "help extract remove failed"
}
