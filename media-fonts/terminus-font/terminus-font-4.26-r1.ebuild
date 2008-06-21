# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/terminus-font/terminus-font-4.26-r1.ebuild,v 1.1 2008/06/21 09:25:04 pva Exp $

EAPI="1"

inherit eutils font

DESCRIPTION="A clean fixed font for the console and X11"
HOMEPAGE="http://www.is-vn.bg/hamster/jimmy-en.html"
SRC_URI="http://www.is-vn.bg/hamster/${P}.tar.gz
		ru-dv? ( http://www.is-vn.bg/hamster/${P}-dv1.diff.gz )
		ru-g? ( http://www.is-vn.bg/hamster/${P}-ge1.diff.gz )
		qoute? ( http://www.is-vn.bg/hamster/${P}-gq2.diff.gz )
		width? ( http://www.is-vn.bg/hamster/${P}-cm2.diff.gz )
		bolddiag? ( http://www.is-vn.bg/hamster/${P}-kx3.diff.gz
				a-like-o? ( http://www.is-vn.bg/hamster/terminus-font-4.26-kx3-ao2.diff.gz )
				ru-i? ( http://www.is-vn.bg/hamster/terminus-font-4.26-kx3-ij1.diff.gz )
				ru-k? ( http://www.is-vn.bg/hamster/terminus-font-4.26-kx3-ka2.diff.gz ) )
		!bolddiag? ( a-like-o? ( http://www.is-vn.bg/hamster/${P}-ao2.diff.gz )
				ru-i? ( http://www.is-vn.bg/hamster/${P}-ij1.diff.gz )
				ru-k? ( http://www.is-vn.bg/hamster/${P}-ka2.diff.gz ) )
			"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="a-like-o ru-dv +ru-g qoute ru-i ru-k width bolddiag"

DEPEND="sys-apps/gawk"

FONTDIR=/usr/share/fonts/terminus
DOCS="README README-BG"

src_unpack() {
	unpack ${A}
	cd "${S}"

	# Upstream patches. Some of them are suggested to be applied by default
	# dv - de NOT like latin g, but like caps greek delta
	#      ve NOT like greek beta, but like caps latin B
	# ge - ge NOT like "mirrored" latin s, but like caps greek gamma
	# ka - small ka NOT like minimised caps latin K, but like small latin k
	if use bolddiag; then
		epatch "${WORKDIR}"/${P}-kx3.diff
		use a-like-o && epatch "${WORKDIR}"/${P}-kx3-ao2.diff
		use ru-i && epatch "${WORKDIR}"/${P}-kx3-ij1.diff
		use ru-k && epatch "${WORKDIR}"/${P}-kx3-ka2.diff
	else
		use a-like-o && epatch "${WORKDIR}"/${P}-ao2.diff
		use ru-i && epatch "${WORKDIR}"/${P}-ij1.diff
		use ru-k && epatch "${WORKDIR}"/${P}-ka2.diff
	fi
	use ru-dv && epatch "${WORKDIR}"/${P}-dv1.diff
	use ru-g && epatch "${WORKDIR}"/${P}-ge1.diff
	use qoute && epatch "${WORKDIR}"/${P}-gq2.diff
	use width && epatch "${WORKDIR}"/${P}-cm2.diff
}

src_compile() {
	# selfwritten configure script
	./configure \
		--prefix=/usr \
		--psfdir=/usr/share/consolefonts \
		--acmdir=/usr/share/consoletrans \
		--unidir=/usr/share/consoletrans \
		--x11dir=${FONTDIR}

	emake psf txt pcf || die
}

src_install() {
	make DESTDIR="${D}" install-psf install-acm install-ref install-pcf || die

	font_src_install
}
