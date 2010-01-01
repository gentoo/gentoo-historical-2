# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-shells/zsh-completion/zsh-completion-20091203.ebuild,v 1.2 2010/01/01 16:37:38 fauli Exp $

inherit eutils

MY_PV="20080310"
DESCRIPTION="Programmable Completion for zsh (includes emerge and ebuild commands)"
HOMEPAGE="http://gzc.tuxfamily.org/"
SRC_URI="http://download.tuxfamily.org/gzc/${PN}-${MY_PV}.tar.bz2"

LICENSE="ZSH"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~s390 ~sh ~sparc ~x86 ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc64-solaris"
IUSE=""

DEPEND=">=app-shells/zsh-4.3.5"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${PN}-${MY_PV}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${PN}-eix-20091203.patch
}

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
