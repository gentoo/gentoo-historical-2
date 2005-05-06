# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-office/magicpoint/magicpoint-1.11b.ebuild,v 1.9 2005/05/06 04:35:58 usata Exp $

inherit elisp-common eutils fixheadtails

DESCRIPTION="an X11 based presentation tool"
SRC_URI="ftp://sh.wide.ad.jp/WIDE/free-ware/mgp/${P}.tar.gz
	ftp://ftp.mew.org/pub/MagicPoint/${P}.tar.gz"
HOMEPAGE="http://member.wide.ad.jp/wg/mgp/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="x86 alpha sparc ppc amd64"
IUSE="cjk nls m17n-lib emacs truetype gif imlib mng"

MY_DEPEND="virtual/x11
	gif? ( >=media-libs/giflib-4.0.1 )
	imlib? ( media-libs/imlib )
	truetype? ( virtual/xft )
	emacs? ( virtual/emacs )
	m17n-lib? ( dev-libs/m17n-lib )
	mng? ( media-libs/libmng )"
DEPEND="${MY_DEPEND}
	sys-devel/autoconf"
RDEPEND="${MY_DEPEND}
	nls? ( sys-devel/gettext )
	truetype? ( cjk? ( media-fonts/sazanami ) )"

SITELISP=/usr/share/emacs/site-lisp
SITEFILE=50mgp-mode-gentoo.el

has_emacs() {
	if has_version 'virtual/emacs' ; then
		true
	else
		false
	fi
}

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${P}-gentoo.diff
	epatch ${FILESDIR}/${P}-mng_optional.patch

	# bug #85720
	sed -i -e "s/ungif/gif/g" configure.in || die
	ht_fix_file configure.in
	autoreconf
}

src_compile() {
	econf \
		$(use_enable gif) \
		$(use_enable imlib) \
		$(use_enable mng) \
		$(use_enable nls locale) \
		$(use_enable truetype xft2) \
		$(use_with m17n-lib) \
		--disable-vflib \
		--disable-freetype \
		--x-libraries=/usr/X11R6/lib || die

	xmkmf || die
	make Makefiles || die
	make clean || die
	make BINDIR=/usr/bin LIBDIR=/etc/X11 || die
}

src_install() {
	make \
		DESTDIR=${D} \
		BINDIR=/usr/bin \
		LIBDIR=/etc/X11 \
		install || die

	make \
		DESTDIR=${D} \
		DOCHTMLDIR=/usr/share/doc/${PF} \
		MANPATH=/usr/share/man \
		MANSUFFIX=1 \
		install.man || die

	exeinto /usr/bin
	doexe contrib/{mgp2html.pl,mgp2latex.pl}

	if use emacs ; then
		insinto ${SITELISP}
		doins contrib/mgp-mode.el ${FILESDIR}/${SITEFILE}
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

pkg_postinst() {
	has_emacs && elisp-site-regen
	einfo
	einfo "If you enabled xft2 support (default) you may specify xfont directive by"
	einfo "font name and font registry."
	einfo "e.g.)"
	einfo '%deffont "standard" xfont "sazanami mincho" "jisx0208.1983"'
	einfo
}

pkg_postrm() {
	has_emacs && elisp-site-regen
}
