# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/jless/jless-382.258.ebuild,v 1.2 2007/02/16 20:36:44 flameeyes Exp $

inherit eutils

LESS_P="less-${PV%%.*}"

DESCRIPTION="Jam less is an enhancement of less which supports multibyte character"
HOMEPAGE="http://www.flash.net/~marknu/less/ http://www.io.com/~kazushi/less/"
JAM_URI="http://www25.big.jp/~jam/less"
SRC_URI="mirror://gnu/less/${LESS_P}.tar.gz
	${JAM_URI}/${LESS_P}-iso258.patch.gz
	${JAM_URI}/${LESS_P}-iso258-259.patch.gz
	${JAM_URI}/${LESS_P}-iso259-260.patch.gz
	${JAM_URI}/${LESS_P}-iso260-261.patch.gz
	${JAM_URI}/${LESS_P}-iso261-262.patch.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE=""

DEPEND="virtual/libc
	>=sys-libs/ncurses-5.2"

S=${WORKDIR}/${LESS_P}

src_unpack() {
	unpack ${LESS_P}.tar.gz
	cd ${S}
	epatch ${DISTDIR}/${LESS_P}-iso258.patch.gz
	epatch ${DISTDIR}/${LESS_P}-iso258-259.patch.gz
	epatch ${DISTDIR}/${LESS_P}-iso259-260.patch.gz
	epatch ${DISTDIR}/${LESS_P}-iso260-261.patch.gz
	epatch ${DISTDIR}/${LESS_P}-iso261-262.patch.gz
}

src_compile() {
	econf \
		--without-cs-regex \
		--with-regex=auto \
		--enable-msb \
		--enable-jisx0213 \
		--with-editor=${EDITOR} \
		|| die

	emake || die
}

src_install() {
	einstall binprefix=j manprefix=j || die

	newbin ${FILESDIR}/lesspipe.sh-r1 jlesspipe.sh

	insinto /etc/env.d
	doins ${FILESDIR}/70jless

	dodoc NEWS README*
}

pkg_postinst() {
	if [ ! -f ${ROOT}/usr/bin/lesspipe.sh ] ; then
		ln -s /usr/bin/jlesspipe.sh ${ROOT}/usr/bin/lesspipe.sh
	fi
}
