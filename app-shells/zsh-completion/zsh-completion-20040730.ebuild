# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/zsh-completion/zsh-completion-20040730.ebuild,v 1.6 2007/01/24 04:00:44 genone Exp $

DESCRIPTION="Programmable Completion for zsh (includes emerge and ebuild commands)"
HOMEPAGE="http://www.zsh.org/"
SRC_URI="http://dev.gentoo.org/~usata/distfiles/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="x86 ppc ~sparc alpha ~arm ~hppa ~amd64 ~ia64 ~ppc-macos"
IUSE=""

DEPEND="app-shells/zsh"

src_install() {

	insinto /usr/share/zsh/site-functions
	doins _*

	dodoc README
}

pkg_postinst() {
	elog
	elog "If you happen to compile your functions, you may need to delete"
	elog "~/.zcompdump{,.zwc} and recompile to make zsh-completion available"
	elog "to your shell."
	elog
}
