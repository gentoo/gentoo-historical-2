# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/latex2html/latex2html-2002.2.1_pre20041025-r1.ebuild,v 1.3 2006/07/02 20:16:58 vapier Exp $

inherit eutils

BASE_PV="${PV/_*/}"	# 2002.2.1_pre20041025 -> 2002.2.1
SNAP_PV="${PV/*_pre/}"	# 2002.2.1_pre20041025 -> 20041025

MY_P="${PN}-${BASE_PV//./-}"		# latex2html-2002-2-1
JA_P="l2h-${BASE_PV//./-}+jp2.0"	# l2h-2002-2-1+jp2.0

S="${WORKDIR}/${MY_P}"

DESCRIPTION="LATEX2HTML is a convertor written in Perl that converts LATEX documents to HTML."
# Downloaded from:
# http://saftsack.fs.uni-bayreuth.de/~latex2ht/current/latex2html-2002-2-1.tar.gz
SRC_URI="mirror://gentoo/${MY_P}+${SNAP_PV}.tar.gz"
#	linguas_ja? ( http://takeno.iee.niit.ac.jp/~shige/TeX/latex2html/data/${JA_P}.patch.gz )"
HOMEPAGE="http://www.latex2html.org/"
#	"http://takeno.iee.niit.ac.jp/~shige/TeX/latex2html/ltx2html.html"

SLOT="0"
LICENSE="as-is"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="gif png"

DEPEND="virtual/ghostscript
	virtual/tetex
	media-libs/netpbm
	dev-lang/perl
	gif? ( media-libs/giflib )
	png? ( media-libs/libpng )"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch "${FILESDIR}/${PN}-convert-length.patch" || die
	epatch "${FILESDIR}/${PN}-perl_name.patch" || die
	epatch "${FILESDIR}/${PN}-extract-major-version.patch" || die
}

src_compile() {
	sed -ie 's%@PERL@%/usr/bin/perl%g' wrapper/unix.pin || die

	local myconf

	use gif || use png || myconf="${myconf} --disable-images"

	econf --libdir=/usr/lib/latex2html \
		--shlibdir=/usr/lib/latex2html \
		--enable-pk \
		--enable-eps \
		--enable-reverse \
		--enable-pipes \
		--enable-paths \
		--enable-wrapper \
		$(use_enable gif) \
		$(use_enable png) \
		${myconf} || die "econf failed"
	make || die
	make check || die
}

src_install() {
	dodir /usr/bin /usr/lib/latex2html /usr/share/latex2html
	dodir /usr/share/texmf/tex/latex/html
	cp cfgcache.pm cfgcache.pm.bak

	# mktexlsr is run later to avoid a sandbox violation
	sed \
		-e "/BINDIR\|LIBDIR\|SHLIBDIR\|TEXPATH/s#q'/#q'"${D}"#" \
		-e "/MKTEXLSR/s:q'.*':q'':" \
		cfgcache.pm.bak > cfgcache.pm

	make install || die
	insinto /usr/lib/latex2html
	newins cfgcache.pm.bak cfgcache.pm

	dodoc BUGS Changes FAQ LICENSE MANIFEST README* TODO

	# make /usr/share/latex2html sticky
	keepdir /usr/share/latex2html

	# clean the perl scripts up to remove references to the sandbox
	einfo "fixing sandbox references"
	einfo ${T}
	dosed "s:${T}:/tmp:g" /usr/lib/latex2html/pstoimg.pl
	dosed "s:${S}::g" /usr/lib/latex2html/latex2html.pl
	dosed "s:${T}:/tmp:g" /usr/lib/latex2html/cfgcache.pm
	dosed "s:${T}:/tmp:g" /usr/lib/latex2html/l2hconf.pm
}

pkg_postinst() {
	einfo "Running mktexlsr to rebuild ls-R database...."
	mktexlsr
}

pkg_postrm() {
	einfo "Running mktexlsr to rebuild ls-R database...."
	mktexlsr
}
