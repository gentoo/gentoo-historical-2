# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/ratpoison/ratpoison-1.3.0.ebuild,v 1.3 2004/08/30 19:19:31 pvdabeel Exp $

inherit elisp-common eutils

DESCRIPTION="Ratpoison is an extremely light-weight and barebones wm modelled after screen"
HOMEPAGE="http://ratpoison.sourceforge.net/"
LICENSE="GPL-2"

SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
KEYWORDS="~x86 ~sparc ppc ~amd64"
IUSE="emacs"

DEPEND="virtual/x11
	emacs? ( virtual/emacs )"

SITEFILE=50ratpoison-gentoo.el

src_unpack() {
	unpack ${A}
	cd ${S}/contrib
	epatch ${FILESDIR}/ratpoison.el-gentoo.patch
}

src_compile() {
	if [ "${ARCH}" = "amd64" ]
	then
		libtoolize -c -f
	fi
	econf || die "econf failed"
	emake CFLAGS="${CFLAGS} -I/usr/X11R6/include" || die
	if use emacs; then
		cd contrib && elisp-comp ratpoison.el
	fi
}

src_install() {
	einstall

	exeinto /etc/X11/Sessions
	newexe ${FILESDIR}/ratpoison.xsession ratpoison

	dodoc INSTALL TODO README NEWS AUTHORS ChangeLog
	docinto example
	dodoc contrib/{genrpbindings,split.sh} \
		doc/{ipaq.ratpoisonrc,sample.ratpoisonrc}

	rm -rf $D/usr/share/{doc/ratpoison,ratpoison}

	if use emacs; then
		elisp-install ${PN} contrib/ratpoison.*
		elisp-site-file-install ${FILESDIR}/${SITEFILE}
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
