# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/magicpoint/magicpoint-1.10a.ebuild,v 1.1 2003/08/06 02:11:54 usata Exp $

use emacs && inherit elisp

IUSE="cjk emacs truetype gif nls imlib"

DESCRIPTION="an X11 based presentation tool"
SRC_URI="ftp://ftp.mew.org/pub/MagicPoint/${P}.tar.gz"
HOMEPAGE="http://www.mew.org/mgp/"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~x86"

DEPEND="virtual/x11
	gif? ( >=media-libs/libungif-4.0.1 )
	imlib? ( media-libs/imlib )
	cjk? ( truetype? ( >=media-libs/vflib-2.25.6-r1 )
		: ( =media-libs/freetype-1* ) )
	truetype? ( =media-libs/freetype-1* )"

RDEPEND="${DEPEND}
	nls? ( sys-devel/gettext )"

SLOT="0"
LICENSE="Sleepycat"
KEYWORDS="~x86"

S=${WORKDIR}/${P}
SITEFILE=50mgp-mode-gentoo.el

src_unpack() {

	unpack ${A}
	epatch ${FILESDIR}/${P}-gentoo.diff
}

src_compile() {
 
	local myconf

	if [ -n "`use cjk`" -a -n "`use truetype`" ] ; then
		myconf="${myconf}
			--enable-vflib
			--with-vfontcap=/usr/share/VFlib/2.25.6/vfontcap.mgp"
	else
		myconf="${myconf} --disable-vflib"

		if [ -n "`use cjk`" ] ; then
			myconf="${myconf} --enable-freetype-charset16"
		elif [ -n "`use truetype`" ] ; then
			myconf="${myconf} --enable-freetype"
		else
			myconf="${myconf} --disable-freetype"
		fi
	fi


	if [ -n "`use nls`" ] ; then
		myconf="${myconf} --enable-locale"
	else
		myconf="${myconf} --disable-locale"
	fi
	
	econf \
		`use_enable gif` \
		`use_enable imlib` \
		--disable-xft2 \
		${myconf} || die

	xmkmf || die
	make Makefiles || die
	make clean || die
	make || die
}

src_install() {

	make \
		DESTDIR=${D} \
		install || die

	make \
		DESTDIR=${D} \
		DOCHTMLDIR=/usr/share/doc/${P} \
		MANPATH=/usr/share/man \
		MANSUFFIX=1 \
		install.man || die

	exeinto /usr/bin
	doexe contrib/{mgp2html.pl,mgp2latex.pl}

	if [ -n "`use emacs`" ] ; then
		elisp-site-file-install contrib/mgp-mode.el
		elisp-site-file-install ${FILESDIR}/${SITEFILE}
	fi

	insinto /usr/share/${PF}/sample
	cd sample
	doins README* cloud.jpg dad.* embed*.mgp gradation*.mgp \
		mgp-old*.jpg mgp.mng mgp3.xbm mgprc-sample \
		multilingual.mgp sample*.mgp sendmail6*.mgp \
		tutorial*.mgp v6*.mgp v6header.* || die
	cd -

	dodoc COPYRIGHT* FAQ README* RELNOTES SYNTAX TODO* USAGE*
}
