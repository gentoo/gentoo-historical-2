# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/showmarks/showmarks-2.2.ebuild,v 1.3 2004/09/06 22:52:27 ciaranm Exp $

inherit vim-plugin

DESCRIPTION="vim plugin: show location marks visually"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=152"

LICENSE="public-domain"
KEYWORDS="~alpha sparc x86 ~ia64 ~ppc ~amd64 mips"
IUSE=""

VIM_PLUGIN_HELPFILES="showmarks.txt"

function src_unpack() {
	unpack ${A}
	mkdir ${S}/doc || die "can't make doc dir"

	# This plugin uses an 'automatic HelpExtractor' variant. This causes
	# problems for us during the unmerge. Fortunately, sed can fix this
	# for us.
	sed -e '1,/^" HelpExtractorDoc:$/d' \
		${S}/plugin/showmarks.vim > ${S}/doc/showmarks.txt \
		|| die "help extraction failed"
	sed -i -e '/^" HelpExtractor:$/,$d' ${S}/plugin/showmarks.vim \
		|| die "help extract remove failed"
}
