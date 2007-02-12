# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/cscope/cscope-15.6-r1.ebuild,v 1.7 2007/02/12 12:55:59 gustavoz Exp $

inherit elisp-common eutils

DESCRIPTION="Interactively examine a C program"
HOMEPAGE="http://cscope.sourceforge.net/"
SRC_URI="mirror://sourceforge/cscope/${P}.tar.gz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm hppa ia64 m68k ~mips ppc ~ppc64 s390 sh sparc ~sparc-fbsd x86 ~x86-fbsd"
IUSE="emacs"

RDEPEND=">=sys-libs/ncurses-5.2"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison
	>=sys-devel/autoconf-2.60
	emacs? ( virtual/emacs )"

SITEFILE=50xcscope-gentoo.el

src_unpack() {
	unpack ${A}

	# warn users of insecure web frontend, see bug #158831
	cd ${S}
	epatch "${FILESDIR}/${PN}-158831-warning_webscope.patch"
}

src_compile() {
	STRIP="no"

	econf || die
	make clean || die
	emake || die

	if use emacs ; then
		cd "${S}"/contrib/xcscope || die
		elisp-compile *.el || die
	fi
}

src_install() {
	einstall || die
	dodoc NEWS AUTHORS TODO ChangeLog INSTALL README* || die

	if use emacs ; then
		cd ${S}/contrib/xcscope || die
		elisp-install xcscope *.el *.elc || die
		elisp-site-file-install ${FILESDIR}/${SITEFILE} xcscope || die
		dobin cscope-indexer || die
	fi
	cp -r ${S}/contrib/webcscope ${D}/usr/share/doc/${PF}/ || die
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
