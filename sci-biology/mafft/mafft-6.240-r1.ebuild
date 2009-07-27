# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/mafft/mafft-6.240-r1.ebuild,v 1.3 2009/07/27 04:23:06 dberkholz Exp $

inherit toolchain-funcs multilib eutils

DESCRIPTION="Multiple sequence alignments using a variety of algorithms"
HOMEPAGE="http://align.bmr.kyushu-u.ac.jp/mafft/software/"
SRC_URI="http://align.bmr.kyushu-u.ac.jp/mafft/software/${P}-src.tgz"
LICENSE="free-noncomm"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND=""
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-mktemp.patch
}

src_compile() {
	cd src
	emake \
		PREFIX="/usr/$(get_libdir)/${PN}" \
		CC="$(tc-getCC)" \
		CFLAG="${CFLAGS}" \
		|| die "make failed"
}

src_install() {
	pushd src
	emake PREFIX="${D}usr/$(get_libdir)/${PN}" install || die "install failed"
	popd
	dodoc readme
}
