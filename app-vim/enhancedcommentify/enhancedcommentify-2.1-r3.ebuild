# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-vim/enhancedcommentify/enhancedcommentify-2.1-r3.ebuild,v 1.2 2005/02/12 18:38:52 ka0ttic Exp $

inherit vim-plugin eutils

DESCRIPTION="vim plugin: enhanced comment creation"
HOMEPAGE="http://www.vim.org/scripts/script.php?script_id=23"
SRC_URI="mirror://gentoo/${P}-r1.tar.bz2"

LICENSE="BSD"
KEYWORDS="~alpha ~amd64 ~ia64 ~mips ~ppc ~sparc ~x86"
IUSE=""

VIM_PLUGIN_HELPFILES="EnhancedCommentify"

DEPEND="${DEPEND} >=sys-apps/sed-4"
# bug #74897
RDEPEND="!app-vim/ctx"

src_unpack() {
	unpack ${A}
	cd ${S}
	# gentooy things, bug #79185
	epatch ${FILESDIR}/${P}-gentooisms.patch
	# add fstab ft support
	sed -i 's/\(xmath\)/\1\\|fstab/' plugin/EnhancedCommentify.vim || \
		die "sed failed"
}
