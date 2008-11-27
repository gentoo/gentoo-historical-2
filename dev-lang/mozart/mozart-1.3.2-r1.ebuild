# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/mozart/mozart-1.3.2-r1.ebuild,v 1.5 2008/11/27 05:32:08 keri Exp $

inherit elisp-common eutils

MY_P="mozart-${PV}.20060615"

DESCRIPTION="Mozart is an advanced development platform for intelligent, distributed applications"
HOMEPAGE="http://www.mozart-oz.org/"
SRC_URI="http://www.mozart-oz.org/download/mozart-ftp/store/1.3.2-2006-06-15-tar/mozart-1.3.2.20060615-src.tar.gz
	doc? ( http://www.mozart-oz.org/download/mozart-ftp/store/1.3.2-2006-06-15-tar/mozart-1.3.2.20060615-doc.tar.gz )"
LICENSE="Mozart"

SLOT="0"
KEYWORDS="-amd64 ~ppc -ppc64 ~sparc ~x86"
IUSE="doc emacs gdbm static tcl threads tk"

RDEPEND="dev-lang/perl
	dev-libs/gmp
	sys-libs/zlib
	emacs? ( virtual/emacs )
	gdbm? ( sys-libs/gdbm  )
	tcl? ( tk? (
			dev-lang/tk
			dev-lang/tcl ) )"
DEPEND="${RDEPEND}
	sys-devel/bison
	sys-devel/flex"

SITEFILE=50${PN}-gentoo.el

S="${WORKDIR}"/${MY_P}

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-portage.patch
	epatch "${FILESDIR}"/${P}-contrib.patch
	epatch "${FILESDIR}"/${P}-emubin.patch
	epatch "${FILESDIR}"/${P}-gcc4.patch
	epatch "${FILESDIR}"/${P}-nostrip.patch
	epatch "${FILESDIR}"/${P}-ozplatform.patch
	epatch "${FILESDIR}"/${P}-ri-fpe.patch
}

src_compile() {
	local myconf="\
			--without-global-oz \
			--enable-opt=none"

	if use tcl && use tk ; then
		myconf="${myconf} --enable-wish"
	else
		myconf="${myconf} --disable-wish"
	fi

	econf \
		${myconf} \
		--enable-contrib \
		--enable-contrib-regex \
		--enable-contrib-os \
		--enable-contrib-micq \
		--enable-contrib-ri \
		--enable-contrib-davinci \
		--enable-contrib-reflect \
		--enable-contrib-investigator \
		--enable-contrib-fcp \
		--enable-contrib-compat \
		--enable-contrib-directory \
		--disable-contrib-psql \
		--disable-contrib-lp \
		--disable-doc \
		$(use_enable doc contrib-doc) \
		$(use_enable gdbm contrib-gdbm) \
		$(use_enable emacs compile-elisp) \
		$(use_enable static link-static) \
		$(use_enable threads threaded) \
		|| die "econf failed"

	emake bootstrap || die "emake bootstrap failed"
}

src_test() {
	cd "${S}"/share/test
	emake -j1 boot-oztest || die "emake boot-oztest failed"
	emake -j1 boot-check || die "emake boot-check failed"
}

src_install() {
	emake \
		PREFIX="${D}"/usr/lib/mozart \
		ELISPDIR="${D}${SITELISP}/${PN}" \
		install || die "emake install failed"

	dosym /usr/lib/mozart/bin/convertTextPickle /usr/bin/convertTextPickle
	dosym /usr/lib/mozart/bin/oldpickle2text /usr/bin/oldpickle2text
	dosym /usr/lib/mozart/bin/oz /usr/bin/oz
	dosym /usr/lib/mozart/bin/ozc /usr/bin/ozc
	dosym /usr/lib/mozart/bin/ozd /usr/bin/ozd
	dosym /usr/lib/mozart/bin/ozengine /usr/bin/ozengine
	dosym /usr/lib/mozart/bin/ozl /usr/bin/ozl
	dosym /usr/lib/mozart/bin/oztool /usr/bin/oztool
	dosym /usr/lib/mozart/bin/pickle2text /usr/bin/pickle2text
	dosym /usr/lib/mozart/bin/text2pickle /usr/bin/text2pickle

	if use emacs; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
			|| die "elisp-site-file-install failed"
	fi

	if use doc ; then
		dohtml -r "${WORKDIR}"/mozart/doc/*
	fi

	dodoc README
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
