# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/slime/slime-2.0.0.20060805.ebuild,v 1.1 2006/08/06 04:24:39 mkennedy Exp $

inherit elisp eutils

DESCRIPTION="SLIME, the Superior Lisp Interaction Mode (Extended)"
HOMEPAGE="http://common-lisp.net/project/slime/"

SRC_URI="mirror://gentoo/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="doc"

DEPEND="virtual/emacs
	dev-lisp/common-lisp-controller
	virtual/commonlisp
	doc? ( sys-apps/texinfo )"

CLPACKAGE=swank

S=${WORKDIR}/slime/slime

src_compile() {
	elisp-comp *.el || die
	use doc && make -C doc slime.info
}

src_install() {
	elisp-install ${PN} *.{el,elc} ${FILESDIR}/${PV}/swank-loader.lisp
	elisp-site-file-install ${FILESDIR}/${PV}/70slime-gentoo.el
	dodoc README* ChangeLog HACKING NEWS PROBLEMS
	zcat ${D}/usr/share/doc/${PF}/ChangeLog.gz \
		>${D}/usr/share/emacs/site-lisp/slime/ChangeLog
	insinto /usr/share/common-lisp/source/swank
	doins *.lisp ${FILESDIR}/${PV}/swank.asd
	dodir /usr/share/common-lisp/systems
	dosym /usr/share/common-lisp/source/swank/swank.asd \
		/usr/share/common-lisp/systems
	dodoc ${FILESDIR}/${PV}/README.Gentoo
	if use doc; then
		doinfo doc/slime.info
	fi
}

pkg_preinst() {
	unregister-common-lisp-source $CLPACKAGE || die
}

pkg_postrm() {
	if ! [ -d /usr/share/common-lisp/source/$CLPACKAGE ]; then
		unregister-common-lisp-source $CLPACKAGE || die
	fi
	elisp-site-regen || die
}

pkg_postinst() {
	register-common-lisp-source $CLPACKAGE || die
	elisp-site-regen || die
	zcat /usr/share/doc/${PF}/README.Gentoo |while read line; do einfo "${line}"; done
}
