# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/rasmol/rasmol-2.7.5-r1.ebuild,v 1.1 2010/03/31 20:43:32 jlec Exp $

EAPI="3"

inherit eutils toolchain-funcs prefix

MY_P="RasMol_${PV}"
VERS="23Jul09"

DESCRIPTION="Molecular Graphics Visualisation Tool"
HOMEPAGE="http://www.openrasmol.org/"
SRC_URI="http://www.rasmol.org/software/${MY_P}.tar.gz"

LICENSE="|| ( GPL-2 RASLIC )"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	x11-libs/cairo
	x11-libs/gtk+:2
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/vte
	dev-libs/cvector
	sci-libs/cbflib
	sci-libs/cqrlib
	sci-libs/neartree"
DEPEND="${RDEPEND}
	x11-proto/inputproto
	x11-proto/xextproto
	app-text/rman
	x11-misc/imake"

S="${WORKDIR}/${P}-${VERS}"

src_prepare() {
	cd src

	if use amd64 || use amd64-linux; then
		mv rasmol.h rasmol_amd64_save.h && \
		echo "#define _LONGLONG"|cat - rasmol_amd64_save.h > rasmol.h
	fi

	mv Imakefile_base Imakefile
	epatch "${FILESDIR}"/${PV}-bundled-lib.patch

	eprefixify Imakefile

	xmkmf -DGTKWIN ${myconf}|| die "xmkmf failed with ${myconf}"
}

src_compile() {
	cd src
	make clean
	emake \
		DEPTHDEF=-DTHIRTYTWOBIT \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		|| die "make failed"
}

src_install () {
	libdir=$(get_libdir)
	insinto /usr/${libdir}/${PN}
	doins doc/rasmol.hlp || die
	dobin src/rasmol || die
	dodoc PROJECTS {README,TODO}.txt doc/*.{ps,pdf}.gz doc/rasmol.txt.gz || die
	doman doc/rasmol.1 || die
	insinto /usr/${libdir}/${PN}/databases
	doins data/* || die

	dohtml -r *html doc/*.html html_graphics || die
}
