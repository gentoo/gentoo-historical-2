# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-editors/nano/nano-1.3.2.ebuild,v 1.9 2004/06/30 03:24:07 agriffis Exp $

inherit eutils

MY_P=${PN}-${PV/_}
DESCRIPTION="GNU GPL'd Pico clone with more functionality"
HOMEPAGE="http://www.nano-editor.org/"
SRC_URI="http://www.nano-editor.org/dist/v1.3/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="x86 ~ppc sparc mips alpha arm hppa amd64 ia64 ~ppc64 s390"
IUSE="nls build spell justify debug slang ncurses nomac wsconvert"

DEPEND=">=sys-libs/ncurses-5.2
	nls? ( sys-devel/gettext )
	slang? ( sys-libs/slang )"
PROVIDE="virtual/editor"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${A}
	cd ${S}
	use nomac && epatch ${FILESDIR}/${PV}-nomac.patch
	use wsconvert && epatch ${FILESDIR}/${PV}-wsconvert.patch
}

src_compile() {
	local myconf=""
	use build && myconf="${myconf} --disable-wrapping-as-root"
	use ncurses || myconf="${myconf} `use_with slang`"

	econf \
		--bindir=/bin \
		--enable-color \
		--enable-multibuffer \
		--enable-nanorc \
		`use_enable justify` \
		`use_enable spell` \
		`use_enable debug` \
		`use_enable nls` \
		${myconf} \
		|| die "configure failed"
	emake || die
}

src_install() {
	make DESTDIR=${D} install || die

	if use build ; then
		rm -rf ${D}/usr/share
	else
		cat ${FILESDIR}/nanorc-* >> doc/nanorc.sample
		dodoc ChangeLog README doc/nanorc.sample AUTHORS BUGS NEWS TODO
		dohtml *.html
		insinto /etc
		newins doc/nanorc.sample nanorc
	fi

	dodir /usr/bin
	dosym ../../bin/nano /usr/bin/nano
}
