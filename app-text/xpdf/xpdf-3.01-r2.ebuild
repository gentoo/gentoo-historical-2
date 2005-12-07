# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/xpdf/xpdf-3.01-r2.ebuild,v 1.7 2005/12/07 17:41:06 metalgod Exp $

inherit eutils

DESCRIPTION="An X Viewer for PDF Files"
HOMEPAGE="http://www.foolabs.com/xpdf/"
SRC_URI="ftp://ftp.foolabs.com/pub/xpdf/${P}.tar.gz
	linguas_ar? ( ftp://ftp.foolabs.com/pub/xpdf/xpdf-arabic.tar.gz )
	linguas_zh_CN? ( ftp://ftp.foolabs.com/pub/xpdf/xpdf-chinese-simplified.tar.gz )
	linguas_zh_TW? ( ftp://ftp.foolabs.com/pub/xpdf/xpdf-chinese-traditional.tar.gz )
	linguas_ru? ( ftp://ftp.foolabs.com/pub/xpdf/xpdf-cyrillic.tar.gz )
	linguas_el? ( ftp://ftp.foolabs.com/pub/xpdf/xpdf-greek.tar.gz )
	linguas_he? ( ftp://ftp.foolabs.com/pub/xpdf/xpdf-hebrew.tar.gz )
	linguas_ja? ( ftp://ftp.foolabs.com/pub/xpdf/xpdf-japanese.tar.gz )
	linguas_ko? ( ftp://ftp.foolabs.com/pub/xpdf/xpdf-korean.tar.gz )
	linguas_la? ( ftp://ftp.foolabs.com/pub/xpdf/xpdf-latin2.tar.gz )
	linguas_th? ( ftp://ftp.foolabs.com/pub/xpdf/xpdf-thai.tar.gz )
	linguas_tr? ( ftp://ftp.foolabs.com/pub/xpdf/xpdf-turkish.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="motif X"

DEPEND="motif? ( !s390? ( virtual/x11
	x11-libs/openmotif ) )
	X? (
		>=media-libs/freetype-2.0.5
		media-libs/t1lib
		virtual/ghostscript
		virtual/x11 )"

RDEPEND="${DEPEND}
	linguas_ja? ( >=media-fonts/kochi-substitute-20030809-r3 )
	linguas_zh_CN? ( >=media-fonts/arphicfonts-0.1-r2 )
	linguas_zh_TW? ( >=media-fonts/arphicfonts-0.1-r2 )
	linguas_ko? ( >=media-fonts/baekmuk-fonts-2.2 )
	!app-text/xpdf-chinese-simplified
	!app-text/xpdf-chinese-traditional
	!app-text/xpdf-cyrillic
	!app-text/xpdf-greek
	!app-text/xpdf-japanese
	!app-text/xpdf-korean
	!app-text/xpdf-latin2
	!app-text/xpdf-thai
	!app-text/xpdf-turkish"
PROVIDE="virtual/pdfviewer"

src_unpack() {
	unpack ${A}
	cd ${S}
	epatch ${FILESDIR}/${PN}-3.00-gcc41.patch
	epatch ${FILESDIR}/${PN}-3.00-64bit.patch
	epatch ${FILESDIR}/${P}-crash.patch
	epatch ${FILESDIR}/${P}-pdftoppm.patch
	epatch ${FILESDIR}/${P}-resize.patch
	epatch ${FILESDIR}/${P}pl1.patch
	autoconf
}

src_compile() {

	local myconf
	if use X; then
		myconf="${myconf} --with-x --enable-freetype2 \
		--with-freetype2-includes=/usr/include/freetype2"
	else
		myconf="${myconf} --without-x --without-freetype2-library"
	fi

	econf \
		${myconf} \
		--enable-opi -enable-multithreaded  || die "Configure Failed"

	emake || die "make failed"
}

src_install() {
	make DESTDIR=${D} install || die "make install failed"
	prepallman
	dodoc README ANNOUNCE CHANGES
	insinto /etc
	newins ${FILESDIR}/xpdfrc.1 xpdfrc

	# install languages, but not on ppc64 (produces crashes...)
	if use !ppc64; then
		use linguas_ar && install_lang turkish
		use linguas_zh_CN && install_lang chinese-simplified
		use linguas_zh_TW && install_lang chinese-traditional
		use linguas_ru && install_lang cyrillic
		use linguas_el && install_lang greek
		use linguas_he && install_lang hebrew
		use linguas_ja && install_lang japanese
		use linguas_ko && install_lang korean
		use linguas_la && install_lang latin2
		use linguas_th && install_lang thai
		use linguas_tr && install_lang turkish
	fi
}

install_lang() {
	cd ../xpdf-$1
	sed 's,/usr/local/share/xpdf/,/usr/share/xpdf/,g' add-to-xpdfrc >> ${D}/etc/xpdfrc
	insinto /usr/share/xpdf/$1
	doins *.unicodeMap
	doins *.cid*
	insinto /usr/share/xpdf/$1/CMap
	doins CMap/*
}

pkg_postinst() {
	use motif || einfo "If you want to compile xpdf binary you have to set USE=motif"
}
