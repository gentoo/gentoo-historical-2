# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-terms/eterm/eterm-0.9.2-r6.ebuild,v 1.4 2005/05/07 23:17:15 vapier Exp $

inherit eutils

MY_PN=${PN/et/Et}
MY_P=${MY_PN}-${PV}
S=${WORKDIR}/${MY_P}
DESCRIPTION="A vt102 terminal emulator for X"
HOMEPAGE="http://www.eterm.org/"
SRC_URI="mirror://sourceforge/eterm/${MY_P}.tar.gz
	mirror://sourceforge/eterm/${MY_PN}-bg-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc sparc x86"
IUSE="mmx etwin escreen"

DEPEND="virtual/x11
	<x11-libs/libast-0.6
	media-libs/imlib2
	etwin? ( app-misc/twin )
	escreen? ( app-misc/screen )"

src_unpack() {
	unpack ${MY_P}.tar.gz
	cd ${S}
	unpack ${MY_PN}-bg-${PV}.tar.gz
	epatch ${FILESDIR}/${PV}-ansi16.patch
	epatch ${FILESDIR}/${PV}-tiling.patch
	sed -i 's:Tw/Tw_1\.h:Tw/Tw1.h:' src/libscream.c
}

src_compile() {
	local myconf
	myconf=""
	if [ "${ARCH}" == "x86" ]; then
		myconf="$myconf `use_enable mmx`"
	else
		myconf="$myconf --disable-mmx"
	fi

	econf \
		--with-imlib \
		--enable-trans \
		--with-x \
		--enable-multi-charset \
		--with-delete=execute \
		--with-backspace=auto \
		`use_enable escreen` \
		`use_enable etwin` \
		${myconf} || die "conf failed"
	emake || die "make failed"
}

src_install() {
	dodir /usr/share/terminfo
	make \
		DESTDIR=${D} \
		TIC="tic -o ${D}/usr/share/terminfo" \
		install || die

	dodoc ChangeLog README ReleaseNotes
	use escreen && dodoc doc/README.Escreen
	dodoc bg/README.backgrounds
}
