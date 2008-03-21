# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/zsh-completion/zsh-completion-20080310.ebuild,v 1.2 2008/03/21 11:43:10 cla Exp $

DESCRIPTION="Programmable Completion for zsh (includes emerge and ebuild commands)"
HOMEPAGE="http://gzc.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/gzc/${PF}.tar.bz2"

LICENSE="ZSH"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~s390 ~sh ~sparc ~sparc-fbsd ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=app-shells/zsh-4.3.5"

src_install() {
	insinto /usr/share/zsh/site-functions
	doins _*

	dodoc AUTHORS
}

pkg_postinst() {
	elog
	elog "If you happen to compile your functions, you may need to delete"
	elog "~/.zcompdump{,.zwc} and recompile to make zsh-completion available"
	elog "to your shell."
	elog
}
