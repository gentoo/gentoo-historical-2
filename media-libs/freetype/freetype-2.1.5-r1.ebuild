# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/freetype/freetype-2.1.5-r1.ebuild,v 1.6 2004/02/26 12:13:41 gmsoft Exp $

inherit eutils flag-o-matic

SPV="`echo ${PV} | cut -d. -f1,2`"

DESCRIPTION="A high-quality and portable font engine"
HOMEPAGE="http://www.freetype.org/"
SRC_URI="mirror://sourceforge/freetype/${P/_/}.tar.bz2"

SLOT="2"
LICENSE="FTL | GPL-2"
KEYWORDS="x86 ~ppc sparc ~alpha hppa ~ia64 ~amd64 ~ppc64"
IUSE="zlib bindist cjk"

DEPEND="virtual/glibc
	zlib? ( sys-libs/zlib )"

src_unpack() {

	unpack ${A}

	cd ${S}
	# add autohint patch from http://www.kde.gr.jp/~akito/patch/freetype2/2.1.5/
	use cjk && epatch ${FILESDIR}/${SPV}/${P}-autohint-cjkfonts-20031105.patch

}

src_compile() {

	local myconf

	use zlib \
		&& myconf="${myconf} --with-zlib" \
		|| myconf="${myconf} --without-zlib"

	use bindist || append-flags "${CFLAGS} -DTT_CONFIG_OPTION_BYTECODE_INTERPRETER"

	make setup CFG="--host=${CHOST} --prefix=/usr ${myconf}" unix || die

	emake || die

	# Just a check to see if the Bytecode Interpreter was enabled ...
	if [ -z "`grep TT_Goto_CodeRange ${S}/objs/.libs/libfreetype.so`" ]
	then
		ewarn "Bytecode Interpreter is disabled."
	fi

}

src_install() {

	make prefix=${D}/usr install || die

	dodoc ChangeLog README
	dodoc docs/{CHANGES,CUSTOMIZE,DEBUG,*.txt,PATENTS,TODO}

	use doc && dohtml -r docs/*

}
